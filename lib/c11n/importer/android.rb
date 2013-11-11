require 'nokogiri'
require 'c11n/types'

module C11n
  module Importer
    class Android
      attr_reader :types, :categories

      def initialize(options = {})
        @path = options[:path]
        @locale = options[:locale]
        @types = {}
        @categories = {}
      end

      def file
        File.open(@path, 'r')
      end

      def document
        Nokogiri::XML(file)
      end

      def import
        { @locale.to_sym => to_hash }
      end

      def to_hash
        document.at_xpath('resources').elements.inject({}) do |result, element|
          if element.name == 'string'
            @types[element['name']] = C11n::Types::CDATA if element.children.any? { |child| child.cdata? }
            result.merge(element['name'] => element.text.strip)
          elsif element.name == 'string-array'
            @types[element['name']] = C11n::Types::ARRAY
            result.merge(element['name'] => element.elements.map(&:text))
          end
        end
      end
    end
  end
end
