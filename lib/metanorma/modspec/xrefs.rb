module Metanorma
  class Requirements
    class Modspec < Default
      def req_class_paths
        [
          { klass: "permissionclass", label: "permissionclass",
            xpath: "permission[@type = 'class']" },
          { klass: "requirementclass", label: "requirementclass",
            xpath: "requirement[@type = 'class']" },
          { klass: "recommendationclass", label: "recommendationclass",
            xpath: "recommendation[@type = 'class']" },
          { klass: "permissiontest", label: "permissiontest",
            xpath: "permission[@type = 'verification']" },
          { klass: "recommendationtest", label: "recommendationtest",
            xpath: "recommendation[@type = 'verification']" },
          { klass: "requirementtest", label: "requirementtest",
            xpath: "requirement[@type = 'verification']" },
          { klass: "abstracttest", label: "abstracttest",
            xpath: "permission[@type = 'abstracttest']" },
          { klass: "abstracttest", label: "abstracttest",
            xpath: "requirement[@type = 'abstracttest']" },
          { klass: "abstracttest", label: "abstracttest",
            xpath: "recommendation[@type = 'abstracttest']" },
          { klass: "conformanceclass", label: "conformanceclass",
            xpath: "permission[@type = 'conformanceclass']" },
          { klass: "conformanceclass", label: "conformanceclass",
            xpath: "requirement[@type = 'conformanceclass']" },
          { klass: "conformanceclass", label: "conformanceclass",
            xpath: "recommendation[@type = 'conformanceclass']" },
          { klass: "permission", label: "permission",
            xpath: "permission[not(@type = 'verification' or @type = 'class' "\
                   "or @type = 'abstracttest' or @type = 'conformanceclass')]" },
          { klass: "recommendation", label: "recommendation",
            xpath: "recommendation[not(@type = 'verification' or "\
                   "@type = 'class' or @type = 'abstracttest' or "\
                   "@type = 'conformanceclass')]" },
          { klass: "requirement", label: "requirement",
            xpath: "requirement[not(@type = 'verification' or @type = 'class' "\
                   "or @type = 'abstracttest' or @type = 'conformanceclass')]" },
        ]
      end

      def req_nested_class_paths
        req_class_paths
      end

      def permission_parts(block, block_id, label, klass)
        block.xpath(ns("./component[@class = 'part']"))
          .each_with_index.with_object([]) do |(c, i), m|
          next if c["id"].nil? || c["id"].empty?

          m << { id: c["id"], number: l10n("#{block_id} #{(i + 'A'.ord).chr}"),
                 elem: c, label: label, klass: klass }
        end
      end

      def postprocess_anchor_struct(block, anchor)
        super
        if l = block.at(ns("./identifier"))&.text
          anchor[:xref] += l10n(": ") + "<tt>#{l}</tt>"
        end
        anchor
      end
    end
  end
end