require_relative "validate"
require_relative "isodoc"
require_relative "lutaml/conformance_class"
require_relative "lutaml/conformance_test"
require_relative "lutaml/normative_statement"
require_relative "lutaml/normative_statements_class"
require_relative "cleanup"

module Metanorma
  class Requirements
    class Modspec < Default
      def initialize(options)
        super
        @modspecidentifierbase = @parent.modspecidentifierbase
      end
    end
  end
end
