module Metanorma
  class Requirements
    class Modspec < Default
      REQT_TYPE_NORM = {
        requirement: "general",
        recommendation: "general",
        permission: "general",
        requirements_class: "class",
        requirement_class: "class",
        recommendation_class: "class",
        permission_class: "class",
        conformance_test: "verification",
        conformance_class: "conformanceclass",
        abstract_test: "abstracttest",
      }.freeze

      def requirement_type_cleanup(reqt)
        ret = REQT_TYPE_NORM[reqt["type"]&.to_sym] or return
        reqt["type"] = ret
      end

      def requirement_metadata_component_tags
        %w(test-purpose test-method test-method-type conditions part description
           reference step guidance) +
          requirement_metadata_requirement_tags
      end

      def requirement_metadata_requirement_tags
        %w(conformance-test conformance-class abstract-test requirement-class
           recommendation-class permission-class requirement permission
           recommendation)
      end

      def requirement_metadata1(reqt, dlist, ins)
        ins1 = super
        dlist.xpath("./dt").each do |e|
          tag = e.text&.gsub(/ /, "-")&.downcase
          next unless requirement_metadata_component_tags.include?(tag)

          ins1.next = requirement_metadata1_component(e, tag)
          ins1 = ins1.next
        end
      end

      def requirement_metadata1_component(term, tag)
        val = term.at("./following::dd")
        val.name = tag
        val.xpath("./dl").each do |d|
          requirement_metadata1(val, d, d)
          d.remove
        end
        requirement_metadata_requirement_tags.include?(term.text) or
          return val
        requirement_metadata1_component_val2id(val)
      end

      def requirement_metadata1_component_val2id(val)
        if val.at(".//link") && val.text.strip.empty?
          val.children = "<identifier>#{val.at('.//link')['target']}</identifier>"
        elsif !val.text.strip.empty?
          val.children = "<identifier>#{val.text.strip}</identifier>"
        end
        val
      end

      # separate from default model requirement_metadata_cleanup,
      # which extracts model:: ogc into reqt["model"]
      def requirement_metadata_cleanup(reqt)
        super
        requirement_metadata_to_component(reqt)
        requirement_metadata_to_requirement(reqt)
        requirement_subparts_to_blocks(reqt)
        requirement_target_identifiers(reqt)
      end

      def requirement_target_identifiers(reqt)
        reqt.xpath("./classification[tag][value/link]").each do |c|
          %w(target indirect-dependency implements identifier-base)
            .include?(c.at("./tag").text.downcase) or next
          v = c.at("./value[link]")
          v.children = v.at("./link/@target").text
        end
      end

      def requirement_metadata_to_component(reqt)
        xpath = requirement_metadata_component_tags - %w(description) -
          requirement_metadata_requirement_tags
        reqt.xpath(xpath.map { |x| ".//#{x}" }.join(" | ")).each do |c|
          c["class"] = c.name
          c.name = "component"
        end
      end

      def requirement_metadata_to_requirement(reqt)
        xpath = requirement_metadata_requirement_tags
        reqt.xpath(xpath.map { |x| "./#{x}" }.join(" | ")).each do |c|
          c["id"] = Metanorma::Utils::anchor_or_uuid
          c["model"] = reqt["model"] # all requirements must have a model
          requirement_metadata_to_requirement1(c)
        end
      end

      def requirement_metadata_to_requirement1(reqt)
        reqt["type"] = reqt.name.sub(/-/, "_")
        reqt.name =
          case reqt.name
          when "recommendation-class", "recommendation" then "recommendation"
          when "permission-class", "permission" then "permission"
          else "requirement"
          end
        requirement_type_cleanup(reqt)
      end

      def requirement_subparts_to_blocks(reqt)
        reqt.xpath(".//component | .//description").each do |c|
          next if %w(p ol ul dl table component description)
            .include?(c&.elements&.first&.name)

          c.children = "<p>#{c.children.to_xml}</p>"
        end
      end

      def add_misc_container(xmldoc)
        unless ins = xmldoc.at("//misc-container")
          a = xmldoc.at("//termdocsource") || xmldoc.at("//bibdata")
          a.next = "<misc-container/>"
          ins = xmldoc.at("//misc-container")
        end
        ins
      end

      def add_misccontainer_anchor_aliases(xmldoc)
        m = add_misc_container(xmldoc)
        x = ".//table[@id = '_misccontainer_anchor_aliases']/tbody"
        unless ins = m.at(x)
          m << "<table id = '_misccontainer_anchor_aliases'><tbody/></table>"
          ins = m.at(x)
        end
        ins
      end

      def requirement_anchor_aliases(reqt)
        x = reqt.xpath("./identifier")
        x.empty? and return
        table = add_misccontainer_anchor_aliases(reqt.document)
        ids = x.each_with_object([]) do |i, m|
          m << "<td>#{i.text}</td>"
        end
        table << "<tr><th>#{reqt['id']}</th>#{ids.join}</tr>"
      end

      def requirement_identifier_cleanup(reqt)
        super
        requirement_anchor_aliases(reqt)
      end
    end
  end
end
