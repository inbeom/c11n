require 'c11n/conversion/plain_deserializer'

module C11n
  # Translations in tabular form. The schema of translations table must match
  # to the schema specified below:
  #
  #   1. If category information exists
  #
  #         [Category] [Key] [Locale 1] [Locale 2] ... [Locale N]
  #
  #   2. If category information does not exist
  #
  #         [Key] [Locale 1] [Locale 2] ... [Locale N]
  #
  # Columns composing the schema must appear on the first row of the sheet.
  class Table
    CATEGORY_COLUMN = 'Category'.freeze
    TYPE_COLUMN = 'Type'.freeze
    KEY_COLUMN = 'Key'.freeze

    def initialize(raw_table, options = {})
      @raw_table = raw_table
      @deserializer_class = options[:deserializer_class] || C11n::Conversion::PlainDeserializer
      @categories = {}
      @types = {}
    end

    # Returns key-value mappings for specified locale as an array
    def table_for(locale)
      @raw_table[1..-1].map do |columns|
        if columns
          key = key_column_from(columns)
          translation = translation_column_from(columns, locale) || ''

          key ? [key, translation] : nil
        else
          nil
        end
      end.compact
    end

    def schema
      @raw_table[0]
    end

    def locales
      has_categories? ? schema[2..-1] : schema[1..-1]
    end

    def categories
      {}
    end

    def types
      if has_types?
        @types = @raw_table[1..-1].inject({}) do |types, columns|
          key = columns[key_column_index]
          type = columns[type_index]

          types.merge(key => type) if type
        end
      else
        {}
      end
    end

    def to_hash
      Hash[locales.map { |locale| [locale.to_sym, @deserializer_class.new(table_for(locale)).deserialize] }]
    end

    def rows
      @raw_table
    end

    def set(locale, key, translation, options = {})
      unless locales.map(&:to_s).map(&:downcase).include? locale.to_s.downcase
        schema[schema.length] = locale
      end

      row_with_key(key)[locale_index_of(locale)] = translation
      row_with_key(key)[category_index] = options[:category] if has_categories? && options[:category]
      row_with_key(key)[type_index] = options[:type] if has_types? && options[:type]
    end

    private

    def key_column_from(columns)
      columns[key_column_index]
    end

    def key_column_index
      schema.map(&:downcase).index(KEY_COLUMN.downcase)
    end

    def translation_column_from(columns, locale)
      columns[locale_index_of(locale)]
    end

    def locale_index_of(locale)
      schema.map(&:downcase).index(locale.to_s.downcase)
    end

    def category_index
      schema.map(&:downcase).index(CATEGORY_COLUMN.downcase)
    end

    def type_index
      schema.map(&:downcase).index(TYPE_COLUMN.downcase)
    end

    def has_categories?
      schema.map(&:downcase).include?(CATEGORY_COLUMN.downcase)
    end

    def has_types?
      schema.map(&:downcase).include?(TYPE_COLUMN.downcase)
    end

    def row_with_key(key)
      @raw_table[1..-1].detect do |row|
        row[key_column_index].to_s == key.to_s
      end || @raw_table[@raw_table.length] = new_row_with_key(key)
    end

    def new_row_with_key(key)
      [].tap do |row|
        row[key_column_index] = key
      end
    end
  end
end
