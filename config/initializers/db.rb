# frozen_string_literal: true

# Create db connection
require 'yaml'

db_config_file = File.join(File.dirname(__FILE__), '..', 'database.yml')
if File.exist?(db_config_file)
  config = YAML.load(ERB.new(File.read(db_config_file)).result, aliases: true)
  DB = Sequel.connect(config[ENV['RACK_ENV']])
end

# Run migrations
if DB
  Sequel.extension :migration
  Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), '..', '..', 'db', 'migrations'))
end
