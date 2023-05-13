# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:ips) do
      primary_key :id

      Integer :type
      TrueClass :is_sync_enabled
      String :ip
    end
  end

  down do
    drop_table(:ips)
  end
end
