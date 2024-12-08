module Metanorma
  class Requirements
    class Default
      def l10n(text)
        @i18n.l10n(text)
      end

      def recommendation_label(elem, type, xrefs)
        label, title = recommendation_labels(elem)
        type = "<span class='fmt-element-name'>#{type}</span>"
        num = xrefs.anchor(elem["id"], :label, false)
        num &&= "<semx element='autonum' source='#{elem['id']}'>#{num}</semx>"
        ret = "#{type} #{num}".strip
        label || title and
          ret += recommendation_label_add(elem, label, title)
        ret
      end

      def recommendation_label_add(elem, label, title)
        r = recommendation_label_caption_delim
        label and
          r += "<semx element='identifier' source='#{elem['id']}'>#{label}</semx>"
        label && title and r += ". "
        title and
          r += "<semx element='title' source='#{elem['id']}'>#{title}</semx>"
        r
      end

      def recommendation_label_caption_delim
        "<span class='fmt-caption-delim'>:<br/></span>"
      end

      def reqt_metadata_node?(node)
        %w(identifier title subject classification tag value
           inherit name fmt-name fmt-xref-label fmt-title).include? node.name
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

      def recommendation_header(_node, out)
        out
      end

      def recommendation_base(node, klass)
        out = node.document.create_element(klass)
        node.attributes.each do |k, v|
          out[k] = v
        end
        n = node.at(ns("./fmt-name")) and out << n
        n = node.at(ns("./fmt-xref-label")) and out << n
        out
      end

      def recommendation_labels(node)
        [node.at(ns("./identifier")), node.at(ns("./title"))]
          .map do |n|
          to_xml(n&.children)
        end
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
        l10n("#{label}: #{to_xml(node.children)}")
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        l10n("#{Metanorma::Utils.strict_capitalize_first tag.text}: " \
             "#{to_xml(value.children)}")
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
        node["exclude"] == "true" and return out
        ret = node.dup
        if reqt_subpart?(node.name)
          ret["type"] = reqt_component_type(node)
          ret.name = "div"
        end
        descr_classif_render(ret)
        out << ret
        out
      end

      def descr_classif_render(reqt)
        reqt.at(ns("./classification")) or return
        ins = reqt.at(ns("./classification")).before("<dl/>").previous
        descr_classif_extract(reqt, ins)
      end

      def descr_classif_extract(desc, ins)
        dlist = desc.xpath(ns("./classification"))
        dlist.each do |x|
          x.at(ns("./tag")).name = "dt"
          x.at(ns("./value")).name = "dd"
          ins << x.children
          x.remove
        end
      end
    end
  end
end
