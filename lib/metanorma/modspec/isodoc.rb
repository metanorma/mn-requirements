require_relative "xrefs"
require_relative "reqt_label"

module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_render1(node)
        node.xpath(ns("//requirement | //recommendation | //permission"))
          .xpath { |r| requirement_render1(r) }
        out = recommendation_base(node, node.name)
        recommendation_header(node, out)
        b = out.add_child("<tbody></tbody>").first
        recommendation_attributes(node, b)
        node.elements.reject do |n|
          reqt_metadata_node?(n)
        end.each { |n| requirement_component_parse(n, out) }
        requirement_table_cleanup(out)
      end

      def recommendation_base(node, klass)
        out = node.document.create_element("table")
        out["id"] = node["id"]
        %w(keep-with-next keep-lines-together unnumbered).each do |x|
          out[x] = node[x] if node[x]
        end
        out["class"] = klass
        out["type"] = recommend_class(node)
        recommendation_component_labels(node)
      end

      def recommendation_component_labels(node)
        node.xpath(ns("./component[@class = 'part']")).each_with_index do |c, i|
          c["label"] = (i + "A".ord).chr.to_s
        end
        node.xpath(ns("./component[not(@class = 'part')]")).each do |c|
          c["label"] = recommend_component_label(c)
        end
      end

      def recommendation_header(recommend, out)
        h = out.add_child("<thead><tr><th scope='colgroup' colspan='2'>"\
                          "</th></tr></thead>").first
        recommendation_name(recommend, h.at(".//th"))
      end

      def recommendation_name(node, out)
        b = out.add_child("<p class='#{recommend_name_class(node)}'></p>").first
        name = node.at(ns("./name")) and name.children.each do |n|
          b << n
        end
        return unless title = node.at(ns("./title")) &&
          node.ancestors("requirement, recommendation, permission").empty?

        b << l10n(": ") if name
        title.children.each { |n| b << n }
      end

      def recommendation_attributes(node, out)
        recommend_title(node, out)
        recommendation_attributes1(node).each do |i|
          out.add_child("<tr><td>#{i[0]}</td><td>#{i[1]}</td></tr>")
        end
      end

      def recommend_title(node, out)
        label = node.at(ns("./identifier")) or return
        b = out.add_child("<tr><td colspan='2'><p></p></td></tr>")
        p = b.at(".//p")
        p["class"] = "RecommendationLabel"
        p << label.children.to_xml
      end

      def recommendation_attributes1(node)
        ret = recommendation_attributes1_head(node, [])
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag",
                                              "value") and ret << line
        end
        ret
      end

      def recommendation_attributes1_head(node, head)
        oblig = node["obligation"] and head << ["Obligation", oblig]
        subj = node.at(ns("./subject"))&.children and
          head << [rec_subj(node), subj]
        node.xpath(ns("./classification[tag = 'target']/value")).each do |v|
          xref = recommendation_id(v.text) and head << [
            rec_target(node), xref
          ]
        end
        %w(general class).include?(node["type"]) and
          xref = recommendation_link(node.document,
                                     node.at(ns("./identifier"))&.text) and
          head << ["Conformance test", xref]
        recommendation_attributes1_dependencies(node, head)
      end

      def recommendation_attributes1_dependencies(node, head)
        node.xpath(ns("./inherit")).each do |i|
          head << ["Dependency",
                   recommendation_id(i.children.to_xml)]
        end
        node.xpath(ns("./classification[tag = 'indirect-dependency']/value"))
          .each do |v|
          xref = recommendation_id(node.document, v.children.to_xml) and
            head << ["Indirect Dependency", xref]
        end
        head
      end

      def recommendation_steps(node)
        node.elements.each { |e| recommendation_steps(e) }
        return node unless node.at(ns("./component[@class = 'step']"))

        d = node.at(ns("./component[@class = 'step']"))
        d = d.replace("<ol class='steps'><li>#{d.children.to_xml}</li></ol>")
          .first
        node.xpath(ns("./component[@class = 'step']")).each do |f|
          f = f.replace("<li>#{f.children.to_xml}</li>").first
          d << f
        end
        node
      end

      def recommendation_attributes1_component(node, out)
        node = recommendation_steps(node)
        out << "<tr><td>#{node['label']}</td><td>#{node.children}</td></tr>"
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}"))
        value = node.at(ns("./#{value}"))
        (tag && value && !%w(target
                             indirect-dependency).include?(tag.text)) or
          return nil
        [tag.text.capitalize, value.children]
      end

      def reqt_component_type(node)
        klass = node.name
        klass == "component" and klass = node["class"]
        "requirement-#{klass}"
      end

      def preserve_in_nested_table?(node)
        %w(recommendation requirement permission
           table ol dl ul).include?(node.name)
      end

      def requirement_component_parse(node, out)
        return if node["exclude"] == "true"

        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        node.name == "component" and
          return recommendation_attributes1_component(node, out)
        b = out.add_child("<tr><td colspan='2'></td></tr>").first
        b.at(".//td") <<
          (preserve_in_nested_table?(node) ? node : node.children)
      end

      def reqt_dl(node, out)
        node.xpath(ns("./dt")).each do |dt|
          dd = dt.next_element
          dd&.name == "dd" or next
          out.add_child("<tr><td>#{dt.children.to_xml}</td>"\
                        "<td>#{dd.children.to_xml}</td></tr>")
        end
      end

      def requirement_table_cleanup(table)
        return unless table["type"] == "recommendclass"

        docxml.xpath(ns("./tbody/tr/td/table")).each do |t|
          t.xpath(ns("./thead | ./tbody |./tfoot")).each do |x|
            x.replace(x.children)
          end
          (x = t.at(ns("./tr/th[@colspan = '2']"))) &&
            (y = t.at(ns("./tr/td[@colspan = '2']"))) and
            requirement_table_cleanup1(x, y)
          t.parent.parent.replace(t.children)
        end
      end

      # table nested in table: merge label and caption into a single row
      def requirement_table_cleanup1(outer, inner)
        outer.delete("colspan")
        outer.delete("scope")
        inner.delete("colspan")
        inner.delete("scope")
        outer.name = "td"
        p = outer.at(ns("./p[@class = 'RecommendationTitle']")) and
          p.delete("class")
        outer.parent << inner.dup
        inner.parent.remove
      end

      def rec_subj(node)
        case node["type"]
        when "class" then "Target type"
        else "Subject"
        end
      end

      def rec_target(node)
        case node["type"]
        when "class" then "Target type"
        when "conformanceclass" then "Requirements class"
        when "verification", "abstracttest" then "Requirement"
        else "Target"
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
        case node["class"]
        when "test-purpose" then "Test purpose"
        when "test-method" then "Test method"
        else Metanorma::Utils.strict_capitalize_first(node["class"])
        end
      end
    end
  end
end
