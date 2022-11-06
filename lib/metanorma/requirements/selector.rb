require_relative "../default/default"
require_relative "../modspec/modspec"
require_relative "../../isodoc/i18n"
require "metanorma-utils"

module Metanorma
  class Requirements
    attr_accessor :i18n, :labels, :modspecidentifierbase

    Hash.include Metanorma::Utils::Hash

    def initialize(options)
      @default = options[:default]
      @i18n = i18n_klass(options[:lang] || "en",
                         options[:script] || "Latn",
                         options[:locale],
                         options[:labels])
      # @labels = @i18n.get.deep_merge(options[:labels] || {})["requirements"]
      @labels = @i18n.get["requirements"]
      @modspecidentifierbase = options[:modspecidentifierbase]
      @models =
        model_names.each_with_object({}) { |k, m| m[k] = create(k) }
    end

    def model_names
      %i[default ogc]
    end

    def i18n_klass(lang, script, locale = nil, i18nhash = nil)
      ::IsoDoc::MnRequirementsI18n.new(lang, script, locale: locale,
                                                     i18nhash: i18nhash)
    end

    # all roles that can be assigned to an example to make it a reqt,
    # across all models (because the model may not be an attribute but
    # embedded in the definition list). Mapped to obligation
    # TODO may need to make it conditional on model
    def requirement_roles
      {
        recommendation: "recommendation",
        requirement: "requirement",
        permission: "permission",
        requirements_class: "requirement",
        conformance_test: "requirement",
        conformance_class: "requirement",
        abstract_test: "requirement",
      }
    end

    def create(type)
      case type
      when :modspec, :ogc
        Metanorma::Requirements::Modspec.new(parent: self)
      else Metanorma::Requirements::Default.new(parent: self)
      end
    end

    def model(type)
      @models[type&.to_sym] || @models[@default]
    end

    REQRECPER = "//requirement | //recommendation | //permission".freeze

    # all cleanup steps by all possible models are included here, and each model
    # can skip a given step. This class iterates through the entire document,
    # and picks the model for each requirement; then that model's method is
    # applied to that particular requirement instance
    def requirement_cleanup(xmldoc)
      requirement_metadata_cleanup(xmldoc)
      requirement_type_cleanup(xmldoc)
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
