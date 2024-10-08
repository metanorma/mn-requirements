require "yaml"
require "isodoc-i18n"

module IsoDoc
  class MnRequirementsI18n < I18n
    def load_yaml1(lang, script)
      case lang
      when "en", "fr", "ru", "de", "es", "ar", "ja"
        load_yaml2(lang)
      when "zh"
        if script == "Hans" then load_yaml2("zh-Hans")
        else load_yaml2("en")
        end
      else load_yaml2("en")
      end
    end

    def load_yaml2(str)
      YAML.load_file(File.join(File.dirname(__FILE__),
                               "../isodoc-yaml/i18n-#{str}.yaml"))
    end
  end
end
