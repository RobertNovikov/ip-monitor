# frozen_string_literal: true

require 'spec_helper'

describe Ips::CreateInteractor do
  let(:enabled) { true }
  let(:ip) { '1.2.3.4' }

  subject { described_class.new.call(ip:, enabled:) }

  context 'when ip created successfully' do
    it 'saves with right params' do
      aggregate_failures do
        is_expected.to be_success
        expect(Ip.last.ip).to eq(ip)
        expect(Ip.last.is_sync_enabled).to eq(enabled)
      end
    end
  end

  context 'when invalid ip' do
    let(:ip) { '1.2.3.4.5.6' }

    it { is_expected.to be_failure }
  end

  context 'when ipv4 created' do
    it 'creates with correct type' do
      subject
      expect(Ip.last.ipv4?).to be_truthy
    end
  end

  context 'when ipv6 created' do
    let(:ip) { '::1' }

    it 'creates with correct type' do
      subject
      expect(Ip.last.ipv6?).to be_truthy
    end
  end
end
