# frozen_string_literal: true

require 'rake'

task :environment do
  ENV['RACK_ENV'] ||= 'development'
  require File.expand_path('config/environment', __dir__)
end

Rake.add_rakelib 'lib/tasks'
