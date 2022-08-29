module Metanorma
  class Requirements
    class Default
      def l10n(text)
        @i18n.l10n(text)
      end

      def recommendation_label(elem, type, xrefs)
        number = xrefs.anchor(elem["id"], :label, false)
        (number.nil? ? type : "#{type} #{number}")
      end

      def reqt_metadata_node?(node)
        %w(identifier title subject classification tag value
           inherit name).include? node.name
      end

      def requirement_render1(node)
        out = recommendation_base(node, node.name)
        ins = recommendation_header(node, out)
        ins = recommendation_attributes(node, ins)
        node.elements.reject do |n|
          reqt_metadata_node?(n)
        end.each { |n| ins = requirement_component_parse(n, ins) }
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
        [node.at(ns("./identifier")), node.at(ns("./title")),
         node.at(ns("./name"))]
          .map do |n|
          n&.children&.to_xml
        end
      end

      def recommendation_header(node, out)
        label, title, name = recommendation_labels(node)
        ret = name ? [name] : []
        if label || title
          ret << l10n(":") unless ret.empty?
          ret += ["<br/>", label]
          ret << l10n(". ") if label && title
          ret << title
        end
        out << "<name>#{ret.compact.join}</name>"
        out
      end

      def recommendation_attributes1(node, out)
        oblig = node["obligation"] and
          out << l10n("#{@labels['default']['obligation']}: #{oblig}")
        node.xpath(ns("./subject")).each do |subj|
          out << l10n("#{@labels['default']['subject']}: #{subj.text}")
        end
        node.xpath(ns("./inherit")).each do |i|
          out << recommendation_attr_parse(i, @labels["default"]["inherits"])
        end
        node.xpath(ns("./classification")).each do |c|
          out << recommendation_attr_keyvalue(c, "tag", "value")
        end
        out
      end

      def recommendation_attr_parse(node, label)
        "#{label}: #{node.children.to_xml}"
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        "#{tag.text.capitalize}: #{value.children.to_xml}"
      end

      def recommendation_attributes(node, out)
        ret = recommendation_attributes1(node, [])
          .map { |a| "<em>#{a}</em>" }
        ret.empty? or
          out << "<p>#{ret.join("<br/>\n")}</p>"
        out
      end

      def reqt_component_type(node)
        klass = node.name
        klass == "component" and klass = node["class"]
        "requirement-#{klass}"
      end

      def requirement_component_parse(node, out)
        return out if node["exclude"] == "true"

        ret = node.dup
        if reqt_subpart?(node.name)
          ret["type"] = reqt_component_type(node)
          ret.name = "div"
        end
        out << ret
        out
      end
    end
  end
end
