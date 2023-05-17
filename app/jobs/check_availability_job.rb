# frozen_string_literal: true

require 'sidekiq'

# Job to check ip and save report
class CheckAvailabilityJob
  include Sidekiq::Job

  def perform
    Ip.where(is_sync_enabled: true).order(:id).paged_each do |row|
      icmp = Net::Ping::ICMP.new(row.ip)
      icmp.timeout = CONSTANTS[:check_interval]
      duration = row.ipv4? ? icmp.ping : icmp.ping6

      retport_params = duration ? { rtt: duration } : { is_packet_lost: true }
      row.add_availability_report(retport_params)
    end
  end
end
