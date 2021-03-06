require 'c11n/conversion/composed_key_deserializer'

module C11n
  module Exporter
    class Yaml
      def initialize(options = {})
        @base_path = options[:base_path]
        @path = options[:path] unless @base_path
      end

      def path_for(locale)
        @path || "#{@base_path}/#{locale}.yml"
      end

      def file
        @file ||= File.new(@path, 'w')
      end

      def export(translations, locale)
        deserialized_translations = C11n::Conversion::ComposedKeyDeserializer.new(translations.translations_for(locale)).deserialize
        file.print(YAML.dump(locale => deserialized_translations))
        file.close
      end
    end
  end
end
