# frozen_string_literal: true

require 'spec_helper'

describe CheckAvailabilityJob do
  let!(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4, is_sync_enabled: true).save }
  let(:result) { 2 }

  subject { described_class.new.perform }

  before { allow(Net::Ping::ICMP).to receive(:new).and_return(OpenStruct.new(timeout: 0, ping: result)) }

  context 'when ping is successful' do
    it 'creates correct report' do
      subject

      expect(ip.availability_reports.last.rtt).to eq(result)
    end
  end

  context 'when lost packet' do
    let(:result) { nil }

    it 'creates correct report' do
      subject

      expect(ip.availability_reports.last.is_packet_lost).to be_truthy
    end
  end
end
