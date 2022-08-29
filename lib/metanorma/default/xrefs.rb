module Metanorma
  class Requirements
    class Default
      def permission_parts(_block, _block_id, _label, _klass)
        []
      end

      def req_class_paths
        [
          { klass: "permission", label: @labels["default"]["permission"],
            xpath: "permission" },
          { klass: "requirement", label: @labels["default"]["requirement"],
            xpath: "requirement" },
          { klass: "recommendation", label: @labels["default"]["recommendation"],
            xpath: "recommendation" },
        ]
      end

      def req_nested_class_paths
        [
          { klass: "permission", label: @labels["default"]["permission"],
            xpath: "permission" },
          { klass: "requirement", label: @labels["default"]["requirement"],
            xpath: "requirement" },
          { klass: "recommendation", label: @labels["default"]["recommendation"],
            xpath: "recommendation" },
        ]
      end

      def postprocess_anchor_struct(_block, anchor)
        anchor
      end
    end
  end
end
