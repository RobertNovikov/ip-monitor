# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app', 'api'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'boot'

Bundler.require :default, ENV.fetch('RACK_ENV', nil)

Dir[File.expand_path('../config/initializers/*.rb', __dir__)].each { |file| require file }
Dir[File.expand_path('../app/helpers/*.rb', __dir__)].each { |file| require file }
Dir[File.expand_path('../app/**/*.rb', __dir__)].each { |file| require file }

require 'app'
require 'base_api'

require 'byebug' if %w[test development].include?(ENV['RACK_ENV'])
