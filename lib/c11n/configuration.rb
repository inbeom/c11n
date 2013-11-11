module C11n
  class Configuration
    attr_reader :configurations, :externals

    class NotConfigured < StandardError; end

    def self.instance
      @instance ||= new
    end

    def initialize
      @configurations = {}
      @externals = {}
    end

    def external(klass)
      if block_given?
        yield(@externals[klass] ||= Configuration.new)

        @externals[klass]
      else
        @externals[klass] || raise(NotConfigured.new)
      end
    end

    def [](key)
      @configurations[key]
    end

    def []=(key, value)
      @configurations[key.to_sym] = value
    end

    def to_hash
      @configurations
    end

    def method_missing(method_name, *args, &block)
      if method_name =~ /(.+)=$/
        @configurations[$1.to_sym] = args.first
      elsif value = @configurations[method_name.to_sym]
        value
      else
        super
      end
    end

    def configure_with_hash(configurations)
      configurations.each do |config_key, config_value|
        @configurations[config_key.to_sym] = config_value
      end
    end

    def load_from_hash(configurations)
      load_external_configurations(configurations.delete(:external) || {})

      configurations.each do |entry, configuration|
        self[entry] = configuration
      end
    end

    def load_external_configurations(externals)
      externals.each do |external_entry, nested_configurations|
        external(external_entry) do |external_config|
          nested_configurations.each do |entry, configuration|
            external_config[entry] = configuration
          end
        end
      end
    end
  end
end
