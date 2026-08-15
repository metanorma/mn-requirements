module Metanorma
  class Requirements
    class Default
      def requirement_type_cleanup(reqt); end

      def requirement_identifier_cleanup(reqt)
        reqt.xpath("./identifier[link] | ./inherit[link]").each do |i|
          i.children = i.at("./link/@target").text
        end
      end

      def requirement_inherit_cleanup(reqt)
        ins = requirement_inherit_insert(reqt)
        reqt.xpath("./*//inherit").each { |i| ins.previous = i }
      end

      def requirement_inherit_insert(reqt)
        ins = reqt.at("./classification") || reqt.at(
          "./description | ./measurementtarget | ./specification | " \
          "./verification | ./import | ./component | " \
          "./requirement | ./recommendation | ./permission",
        ) and return ins
        requirement_inherit_insert1(reqt)
      end

      def requirement_inherit_insert1(reqt)
        if t = reqt.at("./title")
          t.next = " "
          t.next
        else
          if reqt.children.empty? then reqt.add_child(" ")
          else reqt.children.first.previous = " "
          end
          reqt.children.first
        end
      end

      def requirement_descriptions_cleanup(reqt)
        reqt.xpath(".//p[not(./*)][normalize-space(.)='']").each(&:remove)
        reqt.children.each do |e|
          requirement_description_wrap(reqt, e)
        end
        requirement_description_cleanup1(reqt)
      end

      REQS = %w(recommendation requirement permission).freeze

      def requirement_description_wrap(reqt, text)
        return if (text.element? && (reqt_subpart?(text.name) ||
                REQS.include?(text.name))) ||
          (text.text.strip.empty? &&
           !text.at(".//xref | .//eref | .//link | .//origin"))

        t = Nokogiri::XML::Element.new("description", reqt.document)
        text.before(t)
        t.children = text.remove
      end

      def requirement_description_cleanup1(reqt)
        while d = reqt.at("./description[following-sibling::*[1]" \
                          "[self::description]]")
          n = d.next.remove
          d << n.children
        end
        reqt.xpath("./description[normalize-space(.)='']").each do |r|
          r.replace("\n")
        end
      end

      def requirement_metadata_cleanup(reqt)
        dl = reqt.at("./dl[@metadata = 'true']")&.remove or return
        requirement_metadata1(reqt, dl, reqt.at("./title"))
      end

      # The provisions model fixes the metadata head order
      # (title?, identifier?, subject*, inherit*, classification*), but the
      # elements are emitted in authored order, so a requirement authoring its
      # subject after its classifications is invalid. Reorder the metadata head
      # into the canonical sequence, preserving relative order within each type.
      # https://github.com/metanorma/metanorma-standoc/issues/1239
      REQT_METADATA_HEAD = %w(title identifier subject inherit
                              classification).freeze

      def requirement_metadata_reorder(reqt)
        ordered = REQT_METADATA_HEAD.flat_map { |n| reqt.xpath("./#{n}").to_a }
        ordered.size < 2 and return
        ordered.reverse_each do |e|
          e.unlink
          if reqt.children.empty? then reqt.add_child(e)
          else reqt.children.first.previous = e
          end
        end
      end

      def requirement_metadata1_attrs
        %w(obligation model type class render)
      end

      def requirement_metadata1_tags
        %w(identifier subject inherit)
      end

      def requirement_metadata_component_tags
        []
      end

      def dl_to_attrs(elem, dlist, name)
        Metanorma::Utils::dl_to_attrs(elem, dlist, name)
      end

      def dl_to_elems(ins, elem, dlist, name)
        Metanorma::Utils::dl_to_elems(ins, elem, dlist, name)
      end

      def requirement_metadata1(reqt, dlist, ins)
        ins = requirement_metadata1_set_insert(reqt, ins)
        requirement_metadata1_attrs.each do |a|
          dl_to_attrs(reqt, dlist, a)
        end
        requirement_metadata1_tags.each do |a|
          ins = dl_to_elems(ins, reqt, dlist, a)
        end
        ins = reqt_dl_to_classif(ins, reqt, dlist)
        reqt_dl_to_classif1(ins, reqt, dlist)
      end

      def requirement_metadata1_set_insert(reqt, ins)
        ins and return ins
        reqt.children.first.previous = " "
        reqt.children.first
      end

      def unwrap_para(ddef)
        e = ddef.elements and e.size == 1 && e.first.name == "p" and
          ddef = e.first
        to_xml(ddef.children)
      end

      def reqt_dl_to_classif(ins, reqt, dlist)
        if a = reqt.at("./classification[last()]") then ins = a end
        dlist.xpath("./dt[text()='classification']").each do |e|
          val = e.at("./following::dd").text.strip
          req_classif_parse(val).each do |r|
            ins.next = "<classification><tag>#{r[0]}</tag>" \
                       "<value>#{r[1]}</value></classification>"
            ins = ins.next
          end
        end
        ins
      end

      def reqt_dl_to_classif1(ins, reqt, dlist)
        if a = reqt.at("./classification[last()]") then ins = a end
        dlist.xpath("./dt").each do |e|
          next if (requirement_metadata1_attrs + requirement_metadata1_tags +
                   requirement_metadata_component_tags + %w(classification))
            .include?(e.text)

          ins = reqt_dl_to_classif2(e, ins)
        end
        ins
      end

      def reqt_dl_to_classif2(term, ins)
        val = unwrap_para(term.at("./following::dd"))
        ins.next = "<classification><tag>#{term.text}</tag>" \
                   "<value>#{val}</value></classification>"
        ins.next
      end
    end
  end
end
