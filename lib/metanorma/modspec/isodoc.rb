require_relative "xrefs"
require_relative "reqt_label"

module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_render1(node)
        init_lookups(node.document)
        ret = requirement_guidance_parse(node, super)
        requirement_table_cleanup(ret)
      end

      def recommendation_base(node, _klass)
        out = node.document.create_element("table")
        out.default_namespace = node.namespace.href
        %w(id keep-with-next keep-lines-together unnumbered).each do |x|
          out[x] = node[x] if node[x]
        end
        out["class"] = "modspec"
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
        n = recommendation_name(reqt, nil)
        x = if reqt.ancestors("requirement, recommendation, permission").empty?
              "<thead><tr><th scope='colgroup' colspan='2'>"\
                "<p class='#{recommend_name_class(reqt)}'>#{n}</p>"\
                "</th></tr></thead>"
            else
              "<thead><tr><td>#{recommendation_class_label(reqt)}</td>"\
                "<td>#{n}</td></tr></thead>"
            end
        out << x
        out
      end

      def recommendation_name(node, _out)
        ret = ""
        name = node.at(ns("./name")) and ret += name.children.to_xml
        title = node.at(ns("./title"))
        return ret unless title &&
          node.ancestors("requirement, recommendation, permission").empty?

        ret += l10n(": ") unless !name || name.text.empty?
        ret += title.children.to_xml
        ret
      end

      def recommendation_attributes(node, out)
        ins = out.add_child("<tbody></tbody>").first
        recommend_title(node, ins)
        recommendation_attributes1(node).each do |i|
          ins.add_child("<tr><td>#{i[0]}</td><td>#{i[1]}</td></tr>")
        end
        ins
      end

      def recommend_title(node, out)
        label = node.at(ns("./identifier")) or return
        out.add_child("<tr><td scope='colgroup' colspan='2'>"\
                      "<tt>#{label.children.to_xml}</tt></td>")
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
        oblig = node["obligation"] and
          head << [@labels["default"]["obligation"], oblig]
        subj = node.at(ns("./subject"))&.children and
          head << [rec_subj(node), subj]
        node.xpath(ns("./classification[tag = 'target']/value")).each do |v|
          xref = recommendation_id(v.text) and
            head << [rec_target(node), xref]
        end
        head += recommendation_backlinks(node)
        recommendation_attributes1_dependencies(node, head)
      end

      def recommendation_backlinks(node)
        ret = []
        id = node.at(ns("./identifier")) or return ret
        %w(general class).include?(node["type"]) and
          xref = recommendation_link_test(id.text) and
          ret << [@labels["modspec"]["conformancetest"], xref]
        ret
        (node["type"].nil? || node["type"].empty? ||
        node["type"] == "verification") and
          xref = recommendation_link_class(id.text) and
          ret << [@labels["modspec"]["included_in"], xref]
        ret
      end

      def recommendation_attributes1_dependencies(node, head)
        node.xpath(ns("./inherit")).each do |i|
          head << [@labels["modspec"]["dependency"],
                   recommendation_id(i.children.to_xml)]
        end
        node.xpath(ns("./classification[tag = 'indirect-dependency']/value"))
          .each do |v|
          xref = recommendation_id(v.children.to_xml) and
            head << [@labels["modspec"]["indirectdependency"], xref]
        end
        head
      end

      def id_attr(node)
        node["id"] ? " id='#{node['id']}'" : ""
      end

      def recommendation_steps(node)
        node.elements.each { |e| recommendation_steps(e) }
        return node unless node.at(ns("./component[@class = 'step']"))

        d = node.at(ns("./component[@class = 'step']"))
        d = d.replace("<ol class='steps'><li#{id_attr(d)}>"\
                      "#{d.children.to_xml}</li></ol>").first
        node.xpath(ns("./component[@class = 'step']")).each do |f|
          f = f.replace("<li#{id_attr(f)}>#{f.children.to_xml}</li>").first
          d << f
        end
        node
      end

      def recommendation_attributes1_component(node, out)
        return out if node["class"] == "guidance"

        node = recommendation_steps(node)
        out << "<tr#{id_attr(node)}><td>#{node['label']}</td>"\
               "<td>#{node.children}</td></tr>"
        out
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        !%w(target indirect-dependency).include?(tag.text) or return nil
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
        node["exclude"] == "true" and return out
        node.elements.size == 1 && node.first_element_child.name == "dl" and
          return reqt_dl(node.first_element_child, out)
        node.name == "component" and
          return recommendation_attributes1_component(node, out)
        out.add_child("<tr#{id_attr(node)}><td colspan='2'></td></tr>").first
          .at(ns(".//td")) <<
          (preserve_in_nested_table?(node) ? node : node.children)
        out
      end

      def requirement_guidance_parse(node, out)
        ins = out.at(ns("./tbody"))
        node.xpath(ns("./component[@class = 'guidance']")).each do |f|
          ins << "<tr#{id_attr(f)}><td>#{@labels['modspec']['guidance']}</td>"\
                 "<td>#{f.children}</td></tr>"
        end
        out
      end

      def reqt_dl(node, out)
        node.xpath(ns("./dt")).each do |dt|
          dd = dt.next_element
          dd&.name == "dd" or next
          out.add_child("<tr><td>#{dt.children.to_xml}</td>"\
                        "<td>#{dd.children.to_xml}</td></tr>")
        end
        out
      end

      def requirement_table_cleanup(table)
        table.xpath(ns("./tbody/tr/td/table")).each do |t|
          x = t.at(ns("./thead/tr")) or next
          t.parent.parent.replace(x)
        end
        table
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
