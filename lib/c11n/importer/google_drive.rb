require 'c11n/external/google_drive_driver'
require 'c11n/table'

module C11n
  module Importer
    class GoogleDrive
      def initialize(options = {})
        @driver = C11n::External::GoogleDriveDriver.new(options)
      end

      def table
        @table ||= C11n::Table.new(@driver.table)
      end

      def import
        deserialized = {}

        table.to_hash.each do |locale, translations|
          deserialized[locale] = translations.inject({}) do |result, key_and_translation|
            result.merge key_and_translation.first => deserialize(key_and_translation.last, types[key_and_translation.first])
          end
        end

        deserialized
      end

      def categories
        {}
      end

      def types
        table.types
      end

      private

      def deserialize(value, type = nil)
        case type
        when C11n::Types::ARRAY
          value.split("\n\n")
        else
          value
        end
      end
    end
  end
end
