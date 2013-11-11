require 'google_drive'

module C11n
  module External
    class GoogleDriveDriver
      attr_accessor :email, :password, :spreadsheet_key, :worksheet_number

      def initialize(options = {})
        load_from_options(options)
        load_configuration
      end

      def load_from_options(options)
        @email = options[:email]
        @password = options[:password]
        @spreadsheet_key = options[:spreadsheet_key]
        @worksheet_number = options[:worksheet_number]
      end

      def load_configuration
        @email ||= C11n::Configuration.instance.external(:google_drive)[:email]
        @password ||= C11n::Configuration.instance.external(:google_drive)[:password]
        @spreadsheet_key ||= C11n::Configuration.instance.external(:google_drive)[:spreadsheet_key]
        @worksheet_number ||= C11n::Configuration.instance.external(:google_drive)[:worksheet_number]
      end

      def connection
        @connection ||= ::GoogleDrive.login(@email, @password)
      end

      def worksheet
        @worksheet ||= spreadsheet.worksheets[@worksheet_number]
      end

      def spreadsheet
        @spreadsheet ||= connection.spreadsheet_by_key(@spreadsheet_key)
      end

      def table
        raw_table = []

        for row in 1..worksheet.num_rows
          raw_table[row - 1] ||= []

          for col in 1..worksheet.num_cols
            raw_table[row - 1][col - 1] ||= worksheet[row, col]
          end
        end

        raw_table
      end

      def write_table(table)
        table.each_with_index do |row, row_index|
          row.each_with_index do |column, column_index|
            worksheet[row_index + 1, column_index + 1] = column if column
          end
        end

        worksheet.save
      end
    end
  end
end
