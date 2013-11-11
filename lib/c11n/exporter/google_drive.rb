require 'c11n/external/google_drive_driver'
require 'c11n/types'

module C11n
  module Exporter
    class GoogleDrive
      def initialize(options = {})
        @driver = C11n::External::GoogleDriveDriver.new(options)
      end

      def table
        @table ||= C11n::Table.new(@driver.table)
      end

      def export(translations, locale)
        translations.translations_for(locale).each do |key, translation|
          serialized_translation = serialize(translation, translations.types[key])
          table.set(locale, key, serialized_translation, type: translations.types[key], category: translations.categories[key])
        end

        export_table(table)
      end

      def export_table(table)
        @driver.write_table(table.rows)
      end

      private

      def serialize(value, type = nil)
        case type
        when C11n::Types::ARRAY
          value.join("\n\n")
        else
          value
        end
      end
    end
  end
end
