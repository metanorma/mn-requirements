class Nokogiri::XML::Document
  def reqt_iter(&block)
    xpath("//xmlns:requirement | //xmlns:recommendation | //xmlns:permission")
      .each_with_object({}, &block)
  end
end

module Metanorma
  class Requirements
    class Modspec < Default
      def recommendation_label(elem, type, xrefs)
        @xrefs ||= xrefs.dup
        init_lookups(elem.document)

        label = elem.at(ns("./identifier"))&.text
        if inject_crossreference_reqt?(elem, label)
          recommendation_label_xref(elem, label, xrefs, type)
        else
          type = recommendation_class_label(elem)
          super
        end
      end

      def recommendation_label_xref(elem, label, xrefs, type)
        id = @reqtlabels[label]
        number = xrefs.anchor(id, :xref, false)
        number.nil? and return type
        elem.ancestors("requirement, recommendation, permission").empty? and
          return number
        "<xref target='#{id}'>#{number}</xref>"
      end

      def init_lookups(doc)
        return if @init_lookups

        @init_lookups = true
        @reqtlabels = reqtlabels(doc)
        @reqt_ids = reqt_ids(doc)
        @reqt_links_class = reqt_links_class(doc)
        @reqt_links_test = reqt_links_test(doc)
        @reqt_id_base = reqt_id_base(doc)
        truncate_id_base_outside_reqts(doc)
      end

      def reqtlabels(doc)
        doc.reqt_iter do |r, m|
          l = r.at(ns("./identifier"))&.text and m[l] = r["id"]
        end
      end

      # embedded reqts xref to reqts via label lookup
      def inject_crossreference_reqt?(node, label)
        !node.ancestors("requirement, recommendation, permission").empty? and
          @reqtlabels[label]
      end

      def recommendation_class_label(node)
        case node["type"]
        when "verification" then @labels["modspec"]["conformancetest"]
        when "class" then @labels["modspec"]["#{node.name}class"]
        when "abstracttest" then @labels["modspec"]["abstracttest"]
        when "conformanceclass" then @labels["modspec"]["conformanceclass"]
        else
          case node.name
          when "recommendation" then @labels["default"]["recommendation"]
          when "requirement" then @labels["default"]["requirement"]
          when "permission" then @labels["default"]["permission"]
          end
        end
      end

      def reqt_ids(docxml)
        docxml.reqt_iter do |r, m|
          id = r.at(ns("./identifier")) or next
          m[id.text] =
            { id: r["id"], lbl: @xrefs.anchor(r["id"], :xref, false) }
        end
      end

      def reqt_links_test(docxml)
        docxml.reqt_iter { |r, m| reqt_links_test1(r, m) }
      end

      def reqt_links_test1(reqt, acc)
        %w(conformanceclass verification).include?(reqt["type"]) or return
        subj = reqt_extract_target(reqt)
        id = reqt.at(ns("./identifier")) or return
        lbl = @xrefs.anchor(@reqt_ids[id.text.strip][:id], :xref, false)
        (subj && lbl) or return
        acc[subj.text] = { lbl: lbl, id: reqt["id"] }
      end

      def reqt_extract_target(reqt)
        reqt.xpath(ns("./classification[tag][value]")).detect do |x|
          x.at(ns("./tag")).text.casecmp("target").zero?
        end&.at(ns("./value"))
      end

      def reqt_extract_id_base(reqt)
        reqt.xpath(ns("./classification[tag][value]")).detect do |x|
          x.at(ns("./tag")).text.casecmp("identifier-base").zero?
        end&.at(ns("./value"))
      end

      def recommendation_link_test(ident)
        test = @reqt_links_test[ident&.strip] or return nil
        "<xref target='#{test[:id]}'>#{test[:lbl]}</xref>"
      end

      # we have not implemented multiple levels of nesting of classes
      def reqt_links_class(docxml)
        docxml.reqt_iter do |r, m|
          %w(class conformanceclass).include?(r["type"]) or next
          id = r.at(ns("./identifier")) or next
          r.xpath(ns("./requirement | ./recommendation | ./permission"))
            .each do |r1|
            m = reqt_links_class1(id, r, r1, m)
          end
        end
      end

      def reqt_links_class1(id, parent_reqt, reqt, acc)
        id1 = reqt.at(ns("./identifier")) or return acc
        lbl = @xrefs.anchor(@reqt_ids[id.text.strip][:id], :xref, false)
        lbl or return acc
        acc[id1.text] = { lbl: lbl, id: parent_reqt["id"] }
        acc
      end

      def reqt_hierarchy_extract
        @reqt_links_class.each_with_object({}) do |(k, v), m|
          m[v[:id]] ||= []
          m[v[:id]] << @reqt_ids[k][:id]
        end
      end

      def reqt_id_base_init(docxml)
        docxml.reqt_iter { |r, m| m[r["id"]] = reqt_extract_id_base(r)&.text }
      end

      def reqt_id_base_inherit(ret, class2reqt)
        ret.each_key do |k|
          class2reqt[k]&.each do |k1|
            ret[k1] ||= ret[k]
          end
        end
        ret
      end

      def reqt_id_base(docxml)
        ret = reqt_id_base_init(docxml)
        ret = reqt_id_base_inherit(ret, reqt_hierarchy_extract)
        @modspecidentifierbase or return ret
        ret.each_key { |k| ret[k] ||= @modspecidentifierbase }
      end

      def recommendation_link_class(ident)
        test = @reqt_links_class[ident&.strip] or return nil
        "<xref target='#{test[:id]}'>#{test[:lbl]}</xref>"
      end

      def recommendation_id(ident)
        test = @reqt_ids[ident&.strip] or return ident&.strip
        "<xref target='#{test[:id]}'>#{test[:lbl]}</xref>"
      end

      def recommendation_backlinks_test(node, id, ret)
        (%w(general class).include?(node["type"]) &&
          xref = recommendation_link_test(id.text)) or return ret
        lbl = node["type"] == "general" ? "conformancetest" : "conformanceclass"
        ret << [@labels["modspec"][lbl], xref]
        ret
      end

      def recommendation_backlinks_class(node, id, ret)
        (node["type"].nil? || node["type"].empty? ||
        node["type"] == "verification") and
          xref = recommendation_link_class(id.text) and
          ret << [@labels["modspec"]["included_in"], xref]
        ret
      end

      def truncate_id_base_outside_reqts(docxml)
        @modspecidentifierbase or return

        (docxml.xpath(ns("//xref[@style = 'id']")) - docxml
          .xpath(ns("//requirement//xref | //permission//xref | " \
                    "//recommendation//xref"))).each do |x|
          @reqt_id_base[x["target"]] or next # is a modspec requirement
          x.children = x.children.to_xml.delete_prefix(@modspecidentifierbase)
        end
      end

      def rec_subj(node)
        case node["type"]
        when "class" then @labels["modspec"]["targettype"]
        else @labels["default"]["subject"]
        end
      end

      def rec_target(node)
        case node["type"]
        when "class" then @labels["modspec"]["targettype"]
        when "conformanceclass" then @labels["modspec"]["requirementclass"]
        when "verification", "abstracttest" then @labels["default"]["requirement"]
        else @labels["modspec"]["target"]
        end
      end

      def recommend_class(node)
        case node["type"]
        when "verification", "abstracttest" then "recommendtest"
        when "class", "conformanceclass" then "recommendclass"
        else "recommend"
        end
      end

      def recommend_name_class(node)
        if %w(verification abstracttest).include?(node["type"])
          "RecommendationTestTitle"
        else "RecommendationTitle"
        end
      end

      def recommend_component_label(node)
        c = case node["class"]
            when "test-purpose" then "Test purpose"
            when "test-method" then "Test method"
            else node["class"]
            end
        @labels["default"][c] || @labels["modspec"][c] ||
          Metanorma::Utils.strict_capitalize_first(c)
      end
    end
  end
end
