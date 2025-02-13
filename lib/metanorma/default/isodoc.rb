module Metanorma
  class Requirements
    class Default
      def l10n(text)
        @i18n.l10n(text)
      end

      # TODO: move to metanorma-utils
def semx_fmt_dup(elem)
      elem["id"] ||= "_#{UUIDTools::UUID.random_create}"
      new = Nokogiri::XML(<<~XML).root
        <semx xmlns='#{elem.namespace.href}' element='#{elem.name}' source='#{elem['original-id'] || elem['id']}'>#{to_xml(elem.children)}</semx>
      XML
      strip_duplicate_ids(nil, elem, new)
      new
    end

    def gather_all_ids(elem)
      elem.xpath(".//*[@id]").each_with_object([]) do |i, m|
        m << i["id"]
      end
    end

    # remove ids duplicated between sem_title and pres_title
    # index terms are assumed transferred to pres_title from sem_title
    def strip_duplicate_ids(_node, sem_title, pres_title)
      sem_title && pres_title or return
      ids = gather_all_ids(pres_title)
      sem_title.xpath(".//*[@id]").each do |x|
        ids.include?(x["id"]) or next
        x["original-id"] = x["id"]
        x.delete("id")
      end
      sem_title.xpath(ns(".//index")).each(&:remove)
    end

      def recommendation_label(elem, type, xrefs)
        label, title = recommendation_labels(elem)
        type = "<span class='fmt-element-name'>#{type}</span>"
        num = xrefs.anchor(elem["id"], :label, false)
        num &&= "<semx element='autonum' source='#{elem['id']}'>#{num}</semx>"
        ret = num
        /<span class='fmt-element-name'>/.match?(ret) or ret = "#{type} #{num}".strip
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
        out = recommendation_base(node, "fmt-provision")
        ins = recommendation_header(node, out)
        ins = recommendation_attributes(node, ins)
        node.elements.reject do |n|
          reqt_metadata_node?(n)
        end.each { |n| ins = requirement_component_parse(n, ins) }
        requirement_presentation(node, out)
      end

      def requirement_presentation(node, out)
        out.default_namespace = node.namespace.href
        node.xpath(ns("./*//fmt-name | ./*//fmt-xref-label")).each(&:remove)
        node.xpath(ns(".//fmt-sourcecode")).each(&:remove)
        ret = node.dup
        ret << out
        ret
      end

      def recommendation_header(_node, out)
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
        [node.at(ns("./identifier")), node.at(ns("./title"))]
          .map do |n|
           to_xml(n&.children)
        end
      end

      def recommendation_attributes1(node, out)
        oblig = node["obligation"] and
          out << l10n("#{@labels['default']['obligation']}: #{oblig}")
        node.xpath(ns("./subject")).each do |subj|
          #out << l10n("#{@labels['default']['subject']}: #{subj.text}")
          out << l10n("#{@labels['default']['subject']}: #{to_xml(semx_fmt_dup(subj))}")
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
        #l10n("#{label}: #{to_xml(node.children)}")
        l10n("#{label}: #{to_xml(semx_fmt_dup(node))}")
      end

      def recommendation_attr_keyvalue(node, key, value)
        tag = node.at(ns("./#{key}")) or return nil
        value = node.at(ns("./#{value}")) or return nil
        lbl = semx_fmt_dup(tag)
        lbl.children = Metanorma::Utils.strict_capitalize_first(lbl.text)
        l10n("#{to_xml(lbl)}: #{to_xml(semx_fmt_dup(value))}")
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
        reqt_subpart?(node.name) and type = reqt_component_type(node)
        ret = semx_fmt_dup(node)
        descr_classif_render(node, ret)
        t = copy_style_attributes(node)
        type and t += " type='#{type}'"
        out << "<div#{t}>#{to_xml(ret)}</div>"
        out
      end

      def copy_style_attributes(node)
        t = ""
        %w(style keep-with-next keep-lines-together).each do |x|
          node[x] and t += " #{x}='#{node[x]}'"
        end
        t
      end

      def descr_classif_render(node, reqt)
        c = reqt.xpath(ns("./classification"))
        c.empty? and return
        ins = reqt.at(ns("./classification")).before("<dl/>").previous
        descr_classif_extract(node, ins)
        c.each(&:remove)
      end

      def descr_classif_extract(desc, ins)
        dlist = desc.xpath(ns("./classification"))
        dlist.each do |x|
          dt = semx_fmt_dup(x.at(ns("./tag")))
          dd = semx_fmt_dup(x.at(ns("./value")))
          ins << "<dt>#{to_xml dt}</dt><dd>#{to_xml dd}</dd>"
        end
      end
    end
  end
end
