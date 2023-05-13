# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
namespace :db do
  desc 'Prints current schema version'
  task version: :environment do
    next puts 'No schema migrations table' unless DB.tables.include?(:schema_migrations)

    data = DB[:schema_migrations].first
    version = data ? data[:filename].to_s.split('_', 2).first.to_i : 0

    puts "Schema version: #{version}"
  end

  desc 'Run migrations'
  task :migrate, [:version] => :environment do |_, args|
    version = args[:version].to_i if args[:version]
    Sequel::Migrator.run(DB, 'db/migrations', target: version)
    Rake::Task['db:version'].execute
  end

  desc 'Create database'
  task :create do
    config = load_db_config
    next unless config

    db = load_db(config)
    db.execute("CREATE DATABASE \"#{config['database']}\"")
  end

  desc 'Drop database'
  task :drop do
    config = load_db_config
    next unless config

    db = load_db(config)
    db.execute("DROP DATABASE IF EXISTS \"#{config['database']}\"")
  end
end
# rubocop:enable Metrics/BlockLength

def load_db_config
  require 'yaml'
  require 'erb'

  ENV['RACK_ENV'] ||= 'development'

  db_config_file = File.join(File.dirname(__FILE__), '..', '..', 'config', 'database.yml')
  return unless File.exist?(db_config_file)

  config = YAML.load(ERB.new(File.read(db_config_file)).result, aliases: true)
  config[ENV['RACK_ENV']]
end

def load_db(config)
  require 'sequel'
  config_for_create_db = config.except('database').merge('database' => 'postgres')
  Sequel.connect(config_for_create_db)
end
