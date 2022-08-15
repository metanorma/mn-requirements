require_relative '../default/default'

module Metanorma
  class Requirements
    def init
      @models = {}
      model_names.each { |k| @models[k] = create(k) }

    end

    def model_names
      %i(default)
    end

    def create(type)
      case type
      when :default then Metanorma::Requirements::Default.new
      end
    end

    def model(type)
      @models[type]
    end
  end
end
