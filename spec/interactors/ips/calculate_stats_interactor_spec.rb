# frozen_string_literal: true

require 'spec_helper'

describe Ips::CalculateStatsInteractor do
  let(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4).save }
  let(:id) { ip.id }
  let(:one_hour_ago) { Time.now - 1 * 60 * 60 }
  let(:two_hours_ago) { Time.now - 2 * 60 * 60 }
  let(:one_hour_later) { Time.now + 1 * 60 * 60 }
  let(:two_hours_later) { Time.now + 2 * 60 * 60 }

  let!(:old_availability_report) do
    build(:availability_report, ip_id: id, created_at: two_hours_ago, rtt: 8).save
  end

  let!(:new_availability_report) do
    build(:availability_report, ip_id: id, created_at: two_hours_later, rtt: 10).save
  end

  subject do
    described_class.new.call(id:,
                             time_from: one_hour_ago.strftime('%m/%d/%Y %H:%m'),
                             time_to: one_hour_later.strftime('%m/%d/%Y %H:%m'))
  end

  context 'when statistics not found' do
    it { is_expected.to be_failure }
  end

  context 'when statistics found' do
    let!(:rtt_2_report) { build(:availability_report, ip_id: id, rtt: 2).save }

    it 'calls AvailabilityStatsQuery' do
      expect_any_instance_of(AvailabilityStatsQuery).to receive(:call).and_call_original

      is_expected.to be_success
    end
  end
end
