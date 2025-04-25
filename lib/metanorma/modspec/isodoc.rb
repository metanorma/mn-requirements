require_relative "xrefs"
require_relative "reqt_label"
require_relative "table_cleanup"

module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_render1(node)
        init_lookups(node.document)
        ret = requirement_guidance_parse(node, super)
        out = requirement_table_cleanup(node, ret)
        truncate_id_base_fmtxreflabel(out)
        out
      end

      def requirement_presentation(node, out)
        ret = node.document.create_element("fmt-provision")
        ret << out
        out = ret
        super
      end

      def recommendation_base(node, _klass)
        out = node.document.create_element("table")
        out.default_namespace = node.namespace.href
        %w(id keep-with-next keep-lines-together unnumbered).each do |x|
          out[x] = node[x] if node[x]
        end
        node["original-id"] = node["id"]
        node.delete("id")
        out["type"] = recommend_class(node)
        recommendation_component_labels(node)
        out
      end

      def recommendation_component_labels(node)
        node.xpath(ns("./component[@class = 'part']")).each_with_index do |c, i|
          c["label"] = (i + "A".ord).chr.to_s
        end
        node.xpath(ns("./component[not(@class = 'part')]")).each do |c|
          c["label"] = recommend_component_label(c)
        end
      end

      def recommendation_header(reqt, out)
        n = to_xml(reqt.at(ns("./fmt-name")))&.strip
        x = if reqt.ancestors("requirement, recommendation, permission").empty?
              <<~THEAD
                <thead><tr><th scope='colgroup' colspan='2'><p class='#{recommend_name_class(reqt)}'>#{n}</p></th></tr></thead>
              THEAD
            else
              "<thead><tr><th>#{recommendation_class_label(reqt)}</th>" \
                "<td>#{n}</td></tr></thead>"
            end
        out << x
        out
      end

      def recommendation_label_add(elem, _label, title)
        title or return ""
        r = recommendation_label_caption_delim
        title and
          r += "<semx element='title' source='#{elem['id']}'>#{title}</semx>"
        r
      end

      def recommendation_label_caption_delim
        "<span class='fmt-caption-delim'>: </span>"
      end

      def recommendation_labels(node)
        node.ancestors("requirement, recommendation, permission").empty? or
          return [nil, nil]
        super
      end

      def recommendation_attributes(node, out)
        ins = out.add_child("<tbody></tbody>").first
        recommend_title(node, ins)
        recommendation_attributes1(node).each do |i|
          ins.add_child("<tr><th>#{i[0]}</th><td>#{i[1]}</td></tr>")
        end
        ins
      end

      def recommend_title(node, out)
        label = node.at(ns("./identifier")) or return
        ret = <<~OUTPUT
          <tr><th>#{@labels['modspec']['identifier']}</th>
          <td><tt><modspec-ident>#{to_xml(semx_fmt_dup(label))}</modspec-ident></tt></td>
        OUTPUT
        out.add_child(ret)
      end

      def recommendation_attributes1(node)
        ret = recommendation_attributes1_head(node, [])
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag", "value") and
            ret << line
        end
        ret
      end

      def recommendation_attributes1_head(node, head)
        oblig = node["obligation"] and
          head << [@labels["default"]["obligation"], oblig]
        subj = node.at(ns("./subject")) and
          head << [rec_subj(node), semx_fmt_dup(subj)]
        head = recommendation_attributes1_target(node, head)
        head += recommendation_backlinks(node)
        recommendation_attributes1_dependencies(node, head)
      end

      def recommendation_attributes1_target(node, head)
        node.xpath(ns("./classification[tag][value]")).each do |c|
          c.at(ns("./tag")).text.casecmp("target").zero? or next
          xref = recommendation_id(semx_fmt_dup(c.at(ns("./value")))) and
            head << [rec_target(node), xref]
        end
        head
      end

      def recommendation_backlinks(node)
        ret = []
        id = node.at(ns("./identifier")) or return ret
        ret = recommendation_backlinks_test(node, id, ret)
        recommendation_backlinks_class(node, id, ret)
      end

      def recommendation_attributes1_dependencies(node, head)
        head = recommendation_attributes1_inherit(node, head)
        recommendation_attributes_dependencies2(node, head)
      end

      def recommendation_attributes1_inherit(node, head)
        node.xpath(ns("./inherit")).each do |i|
          head << [@labels["modspec"]["dependency"],
                   recommendation_id(semx_fmt_dup(i))]
        end
        head
      end

      def recommendation_attributes_dependencies2(node, head)
        %w(indirect-dependency implements).each do |x|
          node.xpath(ns("./classification[tag][value]")).each do |c|
            c.at(ns("./tag")).text.casecmp(x).zero? or next
            xref = recommendation_id(semx_fmt_dup(c.at(ns("./value")))) and
              head << [@labels["modspec"][x.delete("-")], xref]
          end
        end
        head
      end

      def id_attr(node)
        id = node["id"] || node["original-id"]
        id ? " id='#{id}'" : ""
      end

      def recommendation_steps(node, ret)
        ret.elements.each_with_index do |e, i|
          e1 = nil
          e.name == "component" && e["class"] == "step" and
            e1 = e.replace(semx_fmt_dup(node.elements[i]))
          recommendation_steps(node.elements[i], e1 || e)
        end
        node.name == "component" && node["class"] == "step" and
          ret["inlist"] = "true"
        d = ret.at(ns("./semx[@inlist]")) or return ret
        d.delete("inlist")
        d = d.replace("<ol class='steps'><li#{id_attr(d)}>" \
                      "#{to_xml(d)}</li></ol>").first
        ret.xpath(ns("./semx[@inlist]")).each do |f|
          f.delete("inlist")
          f = f.replace("<li#{id_attr(f)}>#{to_xml(f)}</li>").first
          d << f
        end
        ret
      end

      def recommendation_attributes1_component(node, ret, out)
        node["class"] == "guidance" and return out
        ret = recommendation_steps(node, ret)
        out << "<tr#{id_attr(node)}><th>#{node['label']}</th>" \
          "<td>#{to_xml(ret)}</td></tr>"
        node.delete("label") # inserted in recommendation_component_labels
        out
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        !%w(target indirect-dependency identifier-base
            implements).include?(tag.text.downcase) or
          return nil
        lbl = semx_fmt_dup(tag)
        lbl.children = Metanorma::Utils.strict_capitalize_first(lbl.text)
        [to_xml(lbl), semx_fmt_dup(value)]
      end

      def reqt_component_type(node)
        klass = node.name
        klass == "component" and klass = node["class"]
        "requirement-#{klass}"
      end

      def preserve_in_nested_table?(node)
        !%w(subject inherit identifier measurement-target specification
            verification import description component).include?(node.name)
      end

      def requirement_component_parse(node, out)
        node["exclude"] == "true" and return out
        ret = semx_fmt_dup(node)
        descr_classif_render(node, ret)
        id = node["id"] || node["original-id"]
        id and attr = " id='#{id}'"
        preserve = preserve_in_nested_table?(node)
        if id == node["id"]
          if node["original-id"]
            attr = " id='#{node['original-id']}'"
          else
            node["original-id"] = node["id"]
          end
          node.delete("id")
        end
        if preserve
          n = Nokogiri::XML::Node.new(node.name, node.document)
          node.attributes.each { |k, v| n[k] = v }
          node.children.empty? or n << ret
          ret = n
        end
        ret.elements.size == 1 && ret.first_element_child.name == "dl" and
          return reqt_dl(ret.first_element_child, out)
        node.name == "component" and
          return recommendation_attributes1_component(node, ret, out)
        node.name == "description" and
          return requirement_description_parse(node, ret, out)
        out.add_child("<tr#{attr}><td colspan='2'></td></tr>").first
          .at(ns(".//td")) << (%(permission requirement recommendation).include?(node.name) ? node.dup : ret)
        out
      end

      def requirement_description_parse(node, ret, out)
        lbl = "description"
        recommend_class(node.parent) == "recommend" and
          lbl = "statement"
        out << "<tr><th>#{@labels['modspec'][lbl]}</th>" \
          "<td>#{to_xml(ret)}</td></tr>"
        out
      end

      def requirement_guidance_parse(node, out)
        ins = out.at(ns("./fmt-provision/table/tbody"))
        origs = node.xpath(ns("./component[@class = 'guidance']"))
        out.xpath(ns("./component[@class = 'guidance']")).each_with_index do |f, i|
          f.delete("label")
          ins << "<tr#{id_attr(f)}><th>#{@labels['modspec']['guidance']}</th>" \
            "<td>#{to_xml(semx_fmt_dup(origs[i]))}</td></tr>"
        end
        out
      end

      def reqt_dl(node, out)
        node.xpath(ns("./dt")).each do |dt|
          dd = dt.next_element
          dd&.name == "dd" or next
          out.add_child("<tr><th>#{to_xml(dt.children)}</th>" \
                        "<td>#{to_xml(dd.children)}</td></tr>")
        end
        out
      end
    end
  end
end
