require 'yaml'
require 'c11n/conversion/serializer'
require 'c11n/types'

module C11n
  module Importer
    class Yaml
      def initialize(options = {})
        @base_path = options[:base_path]
        @path = options[:path]
        @types = {}
      end

      def path_for(locale)
        @path || "#{@base_path}/#{locale}.yml"
      end

      def file
        File.open(@path, 'r')
      end

      def import
        raw_yaml = YAML.load(file.read)
        translations = C11n::Conversion::Serializer.new(raw_yaml.values.first).serialize

        translations.each do |key, translation|
          @types[key] = C11n::Types::ARRAY if translation.is_a?(Array)
        end

        { raw_yaml.keys.first => translations }
      end

      def categories
        {}
      end

      def types
        @types
      end
    end
  end
end
