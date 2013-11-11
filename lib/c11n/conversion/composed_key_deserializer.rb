require 'c11n/translations'

module C11n
  module Conversion
    # Deserializes translations in tabular form into Hash.
    class ComposedKeyDeserializer
      attr_accessor :table
      attr_reader :translations

      def initialize(table)
        @table = table
        @translations = {}
      end

      def deserialize
        @table.each do |composed_key, value|
          path = path_for(composed_key)
          create_or_get_leaf_node_for(path)[path.last] = value
        end

        @translations
      end

      def create_or_get_leaf_node_for(path)
        path[0..-2].inject(@translations) do |node, path_component|
          node[path_component] ||= {}
        end
      end

      private

      def path_for(key)
        key.split('.').map(&:to_sym)
      end
    end
  end
end
