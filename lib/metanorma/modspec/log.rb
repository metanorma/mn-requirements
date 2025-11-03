module Metanorma
  class Requirements
    class Modspec
      MODSPEC_LOG_MESSAGES = {
        # rubocop:disable Naming/VariableNumber
        "MODSPEC_1": { category: "Requirements",
                       error: "Requirements linkage: %s %s has no corresponding %s",
                       severity: 2 },
        "MODSPEC_2": { category: "Requirements",
                       error: "Requirements linkage: %s %s points to %s %s outside this document",
                       severity: 2 },
        "MODSPEC_3": { category: "Requirements",
                       error: "Modspec identifier %s is used more than once",
                       severity: 0 },
        "MODSPEC_4": { category: "Requirements",
                       error: "Cycle in Modspec linkages through %s: %s",
                       severity: 2 },
      }.freeze
      # rubocop:enable Naming/VariableNumber
    end
  end
end
