require 'c11n/importer/android'
require 'c11n/exporter/android'

module C11n
  class Synchronizer
    class Android
      RESOURCES = 'res'
      BASE_PATTERN = /^values-?/
      FILE_NAME = 'strings.xml'

      def initialize(options = {})
        @project_root = options[:root]
        @default_locale = options[:default_locale]
      end

      def importers
        @importers ||= Hash[localization_files.map do |locale, file_path|
          [locale, C11n::Importer::Android.new(path: file_path, locale: locale)]
        end]
      end

      def exporters
        @exporters ||= Hash[localization_files.map do |locale, file_path|
          [locale, C11n::Exporter::Android.new(path: file_path)]
        end]
      end

      def localization_files
        @localization_files ||= localization_directories.inject({}) do |files, localization_directory|
          locale = localization_directory.gsub(BASE_PATTERN, '')
          path = File.join(@project_root, RESOURCES, localization_directory, FILE_NAME)

          files.merge (locale.empty? ? @default_locale : locale.to_sym) => path
        end
      end

      def localization_directories
        @localization_directories ||= Dir.new(File.join(@project_root, RESOURCES)).entries.select { |entry| entry =~ BASE_PATTERN }.select do |entry|
          Dir.new(File.join(@project_root, RESOURCES, entry)).entries.include?(FILE_NAME)
        end
      end

      private

      def locale_for(directory_name)
        directory_name == BASE_NAME ? @default_locale.to_sym : directory_name.gsub("#{BASE_NAME}-", '').to_sym
      end
    end
  end
end
