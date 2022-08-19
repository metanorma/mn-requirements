module Metanorma
  class Requirements
    class Modspec < Default
      def requirement_type_cleanup(reqt)
        reqt["type"] = case reqt["type"]
                       when "requirement", "recommendation", "permission"
                         "general"
                       when "requirements_class" then "class"
                       when "conformance_test" then "verification"
                       when "conformance_class" then "conformanceclass"
                       when "abstract_test" then "abstracttest"
                       else reqt["type"]
                       end
      end

      def requirement_metadata_component_tags
        %w(test-purpose test-method test-method-type conditions part description
           reference step requirement permission recommendation)
      end

      def requirement_metadata1(reqt, dlist, ins)
        ins1 = super
        dlist.xpath("./dt").each do |e|
          tag = e&.text&.gsub(/ /, "-")&.downcase
          next unless requirement_metadata_component_tags.include? tag

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
        if REQS.include?(term.text) && !val.text.empty?
          val["label"] = val.text.strip
          val.children.remove
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
        reqt.xpath("./classification[tag = 'target']/value[link]").each do |v|
          v.children = v.at("./link/@target").text
        end
      end

      def requirement_metadata_to_component(reqt)
        reqt.xpath(".//test-method | .//test-purpose | .//conditions | "\
                   ".//part | .//test-method-type | .//step | .//reference")
          .each do |c|
          c["class"] = c.name
          c.name = "component"
        end
      end

      def requirement_metadata_to_requirement(reqt)
        reqt.xpath("./requirement | ./permission | ./recommendation")
          .each do |c|
          c["id"] = Metanorma::Utils::anchor_or_uuid
        end
      end

      def requirement_subparts_to_blocks(reqt)
        reqt.xpath(".//component | .//description").each do |c|
          next if %w(p ol ul dl table component description)
            .include?(c&.elements&.first&.name)

          c.children = "<p>#{c.children.to_xml}</p>"
        end
      end
    end
  end
end
