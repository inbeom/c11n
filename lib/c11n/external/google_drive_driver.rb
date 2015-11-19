require 'google/api_client'
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
        @client_id = options[:client_id]
        @client_secret = options[:client_secret]
        @spreadsheet_key = options[:spreadsheet_key]
        @worksheet_number = options[:worksheet_number]
        @access_token = options[:access_token]
      end

      def load_configuration
        @client_id ||= C11n::Configuration.instance.external(:google_drive)[:client_id]
        @client_secret ||= C11n::Configuration.instance.external(:google_drive)[:client_secret]
        @spreadsheet_key ||= C11n::Configuration.instance.external(:google_drive)[:spreadsheet_key]
        @worksheet_number ||= C11n::Configuration.instance.external(:google_drive)[:worksheet_number]
        @access_token = C11n::Configuration.instance.external(:google_drive)[:access_token]
      end

      def connection
        @connection ||= ::GoogleDrive.login_with_oauth(@access_token || request_access_token)
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

      private

      def request_access_token
        client = ::Google::APIClient.new

        auth = client.authorization
        auth.client_id = @client_id
        auth.client_secret = @client_secret
        auth.scope = ["https://www.googleapis.com/auth/drive"]
        auth.redirect_uri = "urn:ietf:wg:oauth:2.0:oob"

        puts "1. Open this page:\n%s\n\n" % auth.authorization_uri
        puts "2. Enter the authorization code shown in the page: "

        auth.code = $stdin.gets.chomp
        auth.fetch_access_token!

        puts "\n3. You can add the access token to your config file: "
        puts auth.access_token

        auth.access_token
      end
    end
  end
end
