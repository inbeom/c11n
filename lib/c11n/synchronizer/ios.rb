require 'c11n/importer/ios'
require 'c11n/exporter/ios'

module C11n
  class Synchronizer
    class Ios
      LOCALIZABLE = 'Localizable.strings'

      def initialize(options = {})
        @project_root = options[:root]
        @lproj_path = options[:lproj_path] || 'support files'
      end

      def importers
        @importers ||= Hash[localization_files.map do |locale, file_path|
          [locale, C11n::Importer::Ios.new(path: file_path, locale: locale)]
        end]
      end

      def exporters
        @exporters ||= Hash[localization_files.map do |locale, file_path|
          [locale, C11n::Exporter::Ios.new(path: file_path)]
        end]
      end

      def localization_files
        @localization_files ||= localization_directories.inject({}) do |files, localization_directory|
          locale = localization_directory.gsub(/\.lproj$/, '').to_sym
          path = File.join(@project_root, @lproj_path, localization_directory, LOCALIZABLE)

          File.exists?(path) ? files.merge(locale => path) : files
        end
      end

      def locales
        localization_directories.map { |directory| directory.gsub(/\.lproj$/, '') }.map(&:to_sym)
      end

      def localization_directories
        @localization_directories ||= Dir.new(File.join(@project_root, @lproj_path)).entries.select { |entry| entry =~ /lproj$/ }
      end
    end
  end
end
