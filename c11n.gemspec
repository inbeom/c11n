# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'c11n/version'

Gem::Specification.new do |gem|
  gem.name          = 'c11n'
  gem.version       = C11n::VERSION
  gem.authors       = ['Inbeom Hwang']
  gem.email         = ['hwanginbeom@gmail.com']
  gem.description   = %q{Imports/exports i18n translations from/to Google Drive Spreadsheet for easier collaboration.}
  gem.summary       = %q{Manage i18n for your projects using Google Drive.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'google_drive'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'nokogiri'
end
