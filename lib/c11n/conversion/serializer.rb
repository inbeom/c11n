module C11n
  module Conversion
    class Serializer

      class Pair
        attr_accessor :key, :value

        def initialize(key, value)
          @key = key
          @value = value
        end

        def to_a
          [@key, @value]
        end

        def ==(another)
          another.key == @key && another.value == @value
        end
      end

      attr_accessor :translations
      attr_reader :table

      def initialize(translations)
        @translations = translations
        @table = nil
      end

      def serialize
        @table ||= Hash[serialized_translations_for('', @translations).map(&:to_a)]
      end

      private

      def serialized_translations_for(prefix, translations)
        translations.map do |key, value|
          if value.is_a?(Hash)
            serialized_translations_for(child_prefix_for(prefix, key), value)
          else
            Pair.new(child_prefix_for(prefix, key), value)
          end
        end.flatten
      end

      def child_prefix_for(prefix, key)
        prefix.empty? ? key : "#{prefix}.#{key}"
      end
    end
  end
end
