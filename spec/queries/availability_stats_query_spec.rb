# frozen_string_literal: true

require 'spec_helper'

describe AvailabilityStatsQuery do
  let(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4).save }
  let(:id) { ip.id }
  let(:one_hour_ago) { Time.now - 1 * 60 * 60 }
  let(:two_hours_ago) { Time.now - 2 * 60 * 60 }
  let(:one_hour_later) { Time.now + 1 * 60 * 60 }
  let(:two_hours_later) { Time.now + 2 * 60 * 60 }

  let!(:packet_lost_report1) { build(:availability_report, ip_id: id, is_packet_lost: true, rtt: nil).save }
  let!(:packet_lost_report2) { build(:availability_report, ip_id: id, is_packet_lost: true, rtt: nil).save }
  let!(:rtt_2_report) { build(:availability_report, ip_id: id, rtt: 2).save }
  let!(:rtt_4_report) { build(:availability_report, ip_id: id, rtt: 4).save }

  let!(:old_availability_report) do
    build(:availability_report, ip_id: id, created_at: two_hours_ago, rtt: 8).save
  end

  let!(:new_availability_report) do
    build(:availability_report, ip_id: id, created_at: two_hours_later, rtt: 10).save
  end

  let(:expected_result) do
    {
      avg: 3.0,
      max: 4.0,
      median: 3.0,
      min: 2.0,
      packet_lost_percent: 0.5,
      standard_deviation: 1.0
    }
  end

  subject { described_class.new(ip_id: id, time_from: one_hour_ago, time_to: one_hour_later).call.first }

  it 'returns correct statistic' do
    is_expected.to eq(expected_result)
  end
end
