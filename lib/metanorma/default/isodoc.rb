module Metanorma
  class Requirements
    class Default
      def reqt_metadata_node?(node)
        %w(label title subject classification tag value
           inherit name).include? node.name
      end

      def requirement_render1(node)
        out = recommendation_base(node, node.name)
        recommendation_header(node, out)
        recommendation_attributes(node, out)
        node.elements.reject do |n|
          reqt_metadata_node?(n)
        end.each { |n| requirement_component_parse(n, out) }
        out
      end

      def recommendation_base(node, klass)
        out = node.document.create_element(klass)
        node.attributes.each do |k, v|
          out[k] = v
        end
        out
      end

      def recommendation_labels(node)
        [node.at(ns("./label")), node.at(ns("./title")), node.at(ns("./name"))]
          .map do |n|
          n&.children&.to_xml
        end
      end

      def recommendation_header(node, out)
        label, title, name = recommendation_labels(node)
        ret = name ? [name + @parent.i18n.l10n(":")] : []
        if label || title
          ret += ["<br/>", label]
          ret << @parent.i18n.l10n(". ") if label && title
          ret << title
        end
        out << "<name>#{ret.compact.join}</name>"
      end

      def recommendation_attributes1(node, out)
        oblig = node["obligation"] and
          out << @i18n.l10n("#{@labels['obligation']}: #{oblig}")
        node.xpath(ns("./subject")).each do |subj|
          out << @i18n.l10n("#{@labels['subject']}: #{subj.text}")
        end
        node.xpath(ns("./inherit")).each do |i|
          out << recommendation_attr_parse(i, @labels["inherits"])
        end
        node.xpath(ns("./classification")).each do |c|
          line = recommendation_attr_keyvalue(c, "tag",
                                              "value") and out << line
        end
        out
      end

      def recommendation_attr_parse(node, label)
        "#{label}: #{node.children.to_xml}"
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        "#{tag.text.capitalize}: #{value.text}"
      end

      def recommendation_attributes(node, out)
        ret = recommendation_attributes1(node, [])
          .map { |a| "<em>#{a}</em>" }
        return if ret.empty?

        out << "<p>#{ret.join("<br/>\n")}</p>"
      end

      def reqt_component_type(node)
        klass = node.name
        klass == "component" and klass = node["class"]
        "requirement-#{klass}"
      end

      def requirement_component_parse(node, out)
        return if node["exclude"] == "true"

        ret = node.dup
        ret["type"] = reqt_component_type(node)
        ret.name = "div"
        out << ret
      end
    end
  end
end
