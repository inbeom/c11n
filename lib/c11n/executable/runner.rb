require 'c11n/translations'
require 'c11n/synchronizer'

module C11n
  module Executable
    class Runner
      def initialize(options = {})
        @options = options
      end

      def run
        load_config_file

        case task
        when 'push'
          synchronizer.upload
        when 'pull'
          synchronizer.download
        when 'setup'
          synchronizer.setup
        end
      end

      def task
        @options[:task]
      end

      def config_hash
        if @options[:config_file_path]
          @config_hash ||= YAML.load(File.open(@options[:config_file_path]).read)
        end
      end

      def load_config_file
        C11n::Configuration.instance.load_from_hash(config_hash) if config_hash
      end

      def synchronizer
        C11n::Synchronizer.new(configuration: C11n::Configuration.instance)
      end
    end
  end
end
