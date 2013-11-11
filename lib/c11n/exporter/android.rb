require 'nokogiri'
require 'c11n/types'

module C11n
  module Exporter
    class Android
      def initialize(options = {})
        @path = options[:path]
      end

      def file
        @file ||= File.new(@path, 'w')
      end

      def export(translations, locale)
        builder = Nokogiri::XML::Builder.new(encoding: 'utf-8')
        types = translations.types

        root_node = builder.resources do |xml|
          translations.translations_for(locale).each do |key, translation|
            case types[key]
            when C11n::Types::ARRAY
              xml.send(:'string-array') do
                translation.each do |item|
                  xml.item item
                end
              end
            when C11n::Types::CDATA
              xml.string { xml.cdata translation }
            else
              xml.string translation
            end['name'] = key
          end
        end

        file.print builder.to_xml
        file.close
      end
    end
  end
end
