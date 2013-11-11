require 'rubygems'
require 'bundler/setup'
require 'c11n'

Dir['./lib/**/*.rb'].each { |f| require f }
