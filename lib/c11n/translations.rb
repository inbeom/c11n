require 'c11n/conversion/composed_key_deserializer'

module C11n
  class Translations
    attr_reader :categories, :types

    def initialize(options = {})
      @translations = {}
      @deserializer_class = options[:deserializer_class] || C11n::Conversion::ComposedKeyDeserializer
    end

    def add_translation(locale, key, value)
      translations_for(locale.to_sym)[key] = value
    end

    def translation(locale, key)
      translations_for(locale.to_sym)[key]
    end

    def add_translations(locale, translations)
      @translations[locale.to_sym] = translations
    end

    def import_with(importer, given_locale = nil)
      importer.import.each do |locale, imported|
        next if given_locale && given_locale.to_sym != locale.to_sym

        add_translations(locale, imported)
      end

      @categories = importer.categories
      @types = importer.types

      self
    end

    def export_with(exporter, locale)
      exporter.export(self, locale)
    end

    def translations_for(locale)
      @translations[locale.to_sym] ||= {}
    end

    def to_hash
      @translations
    end
  end
end
