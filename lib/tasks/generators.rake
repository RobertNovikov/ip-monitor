# frozen_string_literal: true

require 'fileutils'

namespace :generate do
  desc 'Generates migration'
  task :migration, :name do |_, args|
    migrations_dir = 'db/migrations'
    args.with_defaults(name: 'migration')

    migration_template = <<~MIGRATION
      Sequel.migration do
        up do
        end

        down do
        end
      end
    MIGRATION

    file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}_#{args.name}.rb"
    FileUtils.mkdir_p(migrations_dir)

    File.open(File.join(migrations_dir, file_name), 'w') do |file|
      file.write(migration_template)
    end
  end
end
