require_relative "../default/default"

module Metanorma
  class Requirements
    def initialize(options)
      @default = options[:default]
      @models = {}
      model_names.each { |k| @models[k] = create(k) }
    end

    def model_names
      %i[default]
    end

    def create(type)
      case type
      when :default then Metanorma::Requirements::Default.new
      else Metanorma::Requirements::Default.new
      end
    end

    def model(type)
      @models[type] || @models[@default]
    end

    REQRECPER = "//requirement | //recommendation | //permission".freeze

    # all cleanup steps by all possible models are included here, and each model
    # can skip a given step. This class iterates through the entire document,
    # and picks the model for each requirement; then that model's method is applied
    # to that particular requirement instance
    def requirement_cleanup(xmldoc)
      requirement_type_cleanup(xmldoc)
      requirement_metadata_cleanup(xmldoc)
      requirement_inherit_cleanup(xmldoc)
      requirement_descriptions_cleanup(xmldoc)
      requirement_identifier_cleanup(xmldoc)
    end

    def requirement_type_cleanup(xmldoc)
      xmldoc.xpath(REQRECPER).each do |r|
        model(r["model"]).requirement_type_cleanup(r)
      end
    end

    def requirement_metadata_cleanup(xmldoc)
      xmldoc.xpath(REQRECPER).each do |r|
        model(r["model"]).requirement_metadata_cleanup(r)
      end
    end

    def requirement_inherit_cleanup(xmldoc)
      xmldoc.xpath(REQRECPER).each do |r|
        model(r["model"]).requirement_inherit_cleanup(r)
      end
    end

    def requirement_descriptions_cleanup(xmldoc)
      xmldoc.xpath(REQRECPER).each do |r|
        model(r["model"]).requirement_descriptions_cleanup(r)
      end
    end

    def requirement_identifier_cleanup(xmldoc)
      xmldoc.xpath(REQRECPER).each do |r|
        model(r["model"]).requirement_identifier_cleanup(r)
      end
    end
  end
end
