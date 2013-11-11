require 'c11n/translations'
require 'c11n/importer/yaml'
require 'c11n/exporter/yaml'

module C11n
  class Synchronizer
    class Rails
      def initialize(options = {})
        @project_root = options[:root]
      end

      def importers
        @importers ||= Hash[localization_files.map do |locale, file_path|
          [locale, C11n::Importer::Yaml.new(path: file_path)]
        end]
      end

      def exporters
        @exporters ||= Hash[localization_files.map do |locale, file_path|
          [locale, C11n::Exporter::Yaml.new(path: file_path)]
        end]
      end

      def localization_files
        Dir.new(locales_parent_directory_path).entries.select { |entry| entry =~ /\.yml$/ }.inject({}) do |files, entry|
          files.merge locale_for(entry) => File.join(locales_parent_directory_path, entry)
        end
      end

      def locales_parent_directory_path
        File.join(@project_root, 'config/locales')
      end

      private

      def locale_for(localization_file)
        localization_file.gsub(/\.yml$/, '').to_sym
      end
    end
  end
end
