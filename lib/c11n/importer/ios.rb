module C11n
  module Importer
    class Ios
      attr_reader :types, :categories

      def initialize(options = {})
        @path = options[:path]
        @locale = options[:locale]
        @types = {}
        @categories = {}
      end

      def import
        result = {}

        file.each_line do |line|
          result.merge parse(line)
        end

        result
      end

      def file
        File.open(@path, 'r')
      end

      private

      def parse(line)
        matched_data = line.scan(/"([^"]+)"\s*=\s*"([^"]*)"/).first

        matched_data && { matched_data.first => matched_data.last }
      end
    end
  end
end
