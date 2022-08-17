require "metanorma-utils"

module Metanorma
  class Requirements
    class Default
      def noko(&block)
        Metanorma::Utils.noko(&block)
      end

      def attr_code(attributes)
        Metanorma::Utils.attr_code(attributes)
      end

      def csv_split(text, delim = ";")
        Metanorma::Utils.csv_split(text, delim)
      end

      def wrap_in_para(node, out)
        Metanorma::Utils.wrap_in_para(node, out)
      end
    end
  end
end
