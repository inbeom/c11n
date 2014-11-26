# C11n

C11n enables you to collaborate on i18n for your apps easily using Google
Drive. It can upload locales in your project to Google Drive Spreadsheet and
download contents from Google Drive Spreadsheet and modify your source files
up to date.

Default conventions for Rails/Android/iOS application projects are supported.

## Installation

C11n runs from command line. Install it via Rubygems as:

    $ gem install c11n

You may need to install additional libraries c11n depends on:

    $ gem install nokogiri # for parsing XML files in Android projects

## Usage

You need to make your own configuration file for your projects. Example:

    ---
    :external:
      :google_drive:
        :email: [EMAIL ADDRESS OF YOUR GOOGLE ACCOUNT]
        :password: [PASSWORD FOR YOUR GOOGLE ACCOUNT]
        :spreadsheet_key: [KEY OF SPREADSHEET CONTAINS LOCALES FOR YOUR APPLICATION]
        :worksheet_number: [0-BASED INDEX OF YOUR WORKSHEET]
    :type: [TYPE OF YOUR PROJECT: android, ios, rails]
    :root: [ROOT DIRECTORY OF YOUR PROJECT]
    :res_path: ['res' DIRECTORY OF YOUR PROJECT - ONLY FOR android]
    :default_locale: [DEFAULT LOCALE FOR YOUR PROJECT - ONLY FOR android]

After writing configuration file, you can set up a spreadsheet for your project
with `setup` task. You may skip this step if you have a spreadsheet already.

    $ c11n -c [PATH TO CONFIG FILE] setup

After setting up the spreadsheet, you can move your i18n dat to/from google
drive using these commands:

    $ c11n -c [PATH TO CONFIG FILE] push
    $ c11n -c [PATH TO CONFIG FILE] pull

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
