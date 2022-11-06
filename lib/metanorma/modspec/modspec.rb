require_relative "cleanup"
require_relative "validate"
require_relative "isodoc"

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
