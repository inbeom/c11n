module C11n
  module Conversion
    class PlainDeserializer
      attr_accessor :table
      attr_reader :translations

      def initialize(table)
        @table = table
        @translations = {}
      end

      def deserialize
        @table.each do |key, value|
          @translations[key] = value
        end

        @translations
      end
    end
  end
end
