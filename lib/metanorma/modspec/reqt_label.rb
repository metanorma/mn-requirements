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
      end

      def reqtlabels(doc)
        doc.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
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
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            id = r.at(ns("./identifier")) or next
            m[id.text] =
              { id: r["id"], lbl: @xrefs.anchor(r["id"], :xref, false) }
          end
      end

      def reqt_links_test(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            reqt_links_test1(r, m)
          end
      end

      def reqt_links_test1(reqt, acc)
        return unless %w(conformanceclass
                         verification).include?(reqt["type"])

        subj = reqt_extract_target(reqt)
        id = reqt.at(ns("./identifier")) or return
        lbl = @xrefs.anchor(@reqt_ids[id.text.strip][:id], :xref, false)
        return unless subj && lbl

        acc[subj.text] = { lbl: lbl, id: reqt["id"] }
      end

      def reqt_extract_target(reqt)
        reqt.xpath(ns("./classification[tag][value]")).detect do |x|
          x.at(ns("./tag")).text.casecmp("target").zero?
        end&.at(ns("./value"))
      end

      def recommendation_link_test(ident)
        test = @reqt_links_test[ident&.strip] or return nil
        "<xref target='#{test[:id]}'>#{test[:lbl]}</xref>"
      end

      def reqt_links_class(docxml)
        docxml.xpath(ns("//requirement | //recommendation | //permission"))
          .each_with_object({}) do |r, m|
            next unless %w(class conformanceclass).include?(r["type"])

            id = r.at(ns("./identifier")) or next
            r.xpath(ns("./requirement | ./recommendation | ./permission"))
              .each do |r1|
              id1 = r1.at(ns("./identifier")) or next
              lbl = @xrefs.anchor(@reqt_ids[id.text.strip][:id], :xref, false)
              next unless lbl

              m[id1.text] = { lbl: lbl, id: r["id"] }
            end
          end
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
    end
  end
end
