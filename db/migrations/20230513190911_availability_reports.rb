# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:availability_reports) do
      primary_key :id
      foreign_key :ip_id, :ips

      TrueClass :is_packet_lost, default: false
      Float :rtt
      DateTime :created_at, default: Sequel::CURRENT_TIMESTAMP

      index %i[ip_id]
    end
  end

  down do
    drop_table(:availability_reports)
  end
end
