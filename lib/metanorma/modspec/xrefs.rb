module Metanorma
  class Requirements
    class Modspec < Default
      def req_class_paths
        [
          { klass: "permissionclass",
            label: @labels["modspec"]["permissionclass"],
            xpath: "permission[@type = 'class']" },
          { klass: "requirementclass",
            label: @labels["modspec"]["requirementclass"],
            xpath: "requirement[@type = 'class']" },
          { klass: "recommendationclass",
            label: @labels["modspec"]["recommendationclass"],
            xpath: "recommendation[@type = 'class']" },
          { klass: "permissiontest",
            label: @labels["modspec"]["conformancetest"],
            xpath: "permission[@type = 'verification']" },
          { klass: "recommendationtest",
            label: @labels["modspec"]["conformancetest"],
            xpath: "recommendation[@type = 'verification']" },
          { klass: "requirementtest",
            label: @labels["modspec"]["conformancetest"],
            xpath: "requirement[@type = 'verification']" },
          { klass: "abstracttest",
            label: @labels["modspec"]["abstracttest"],
            xpath: "permission[@type = 'abstracttest']" },
          { klass: "abstracttest",
            label: @labels["modspec"]["abstracttest"],
            xpath: "requirement[@type = 'abstracttest']" },
          { klass: "abstracttest",
            label: @labels["modspec"]["abstracttest"],
            xpath: "recommendation[@type = 'abstracttest']" },
          { klass: "conformanceclass",
            label: @labels["modspec"]["conformanceclass"],
            xpath: "permission[@type = 'conformanceclass']" },
          { klass: "conformanceclass",
            label: @labels["modspec"]["conformanceclass"],
            xpath: "requirement[@type = 'conformanceclass']" },
          { klass: "conformanceclass",
            label: @labels["modspec"]["conformanceclass"],
            xpath: "recommendation[@type = 'conformanceclass']" },
          { klass: "permission",
            label: @labels["default"]["permission"],
            xpath: "permission[not(@type = 'verification' or @type = 'class' " \
                   "or @type = 'abstracttest' or @type = 'conformanceclass')]" },
          { klass: "recommendation",
            label: @labels["default"]["recommendation"],
            xpath: "recommendation[not(@type = 'verification' or " \
                   "@type = 'class' or @type = 'abstracttest' or " \
                   "@type = 'conformanceclass')]" },
          { klass: "requirement",
            label: @labels["default"]["requirement"],
            xpath: "requirement[not(@type = 'verification' or @type = 'class' " \
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
        anchor[:xref_bare] = anchor[:xref]
        l = block.at(ns("./identifier")) and
          anchor[:xref] += l10n(": ") +
            "<tt><xref style='id' target='#{block['id']}'>#{to_xml semx_fmt_dup(l)}</xref></tt>"
        anchor[:modspec] = anchor[:xref]
        anchor
      end
    end
  end
end
