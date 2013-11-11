require 'c11n/version'
require 'c11n/configuration'

module C11n
  def self.configure
    yield C11n::Configuration.instance
  end
end
