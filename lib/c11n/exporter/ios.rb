module C11n
  module Exporter
    class Ios
      def initialize(options = {})
        @path = options[:path]
      end

      def export(translations, locale)
        file.print(translations.translations_for(locale).map do |key, translation|
          "\"#{key}\" = \"#{translation}\";"
        end.join("\n"))

        file.close
      end

      def file
        @file ||= File.new(@path, 'w')
      end
    end
  end
end
