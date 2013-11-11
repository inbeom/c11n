require 'c11n/configuration'
require 'c11n/translations'
require 'c11n/importer/google_drive'
require 'c11n/exporter/google_drive'
require 'c11n/synchronizer/ios'
require 'c11n/synchronizer/android'
require 'c11n/synchronizer/rails'

module C11n
  class Synchronizer
    def project
      @project ||= case @configuration.type
      when 'ios'
        C11n::Synchronizer::Ios.new(@configuration.to_hash)
      when 'android'
        C11n::Synchronizer::Android.new(@configuration.to_hash)
      when 'rails'
        C11n::Synchronizer::Rails.new(@configuration.to_hash)
      end
    end

    def initialize(options = {})
      @configuration = options[:configuration]
      @translations = C11n::Translations.new
    end

    def google_drive_importer
      @google_drive_importer ||= C11n::Importer::GoogleDrive.new
    end

    def google_drive_exporter
      @google_drive_exporter ||= C11n::Exporter::GoogleDrive.new
    end

    def upload
      project.importers.each do |locale, importer|
        @translations.import_with(importer)
        @translations.export_with(google_drive_exporter, locale)
      end
    end

    def download
      @translations.import_with(google_drive_importer)

      project.exporters.each do |locale, exporter|
        @translations.export_with(exporter, locale)
      end
    end

    def setup
      schema = [C11n::Table::CATEGORY_COLUMN, C11n::Table::KEY_COLUMN, C11n::Table::TYPE_COLUMN] + project.importers.keys.map(&:to_s)

      table_with_schema = C11n::Table.new([schema])

      google_drive_exporter.export_table(table_with_schema)
    end
  end
end
