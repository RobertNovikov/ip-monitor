# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IpsContainer do
  let(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4, is_sync_enabled: true).save }
  let(:id) { ip.id }

  describe 'find_ip' do
    subject { described_class.resolve(:find_ip).call(id: id) }

    context 'when ip found' do
      it { expect(subject.success).to eq(ip) }
    end

    context 'when ip not found' do
      let(:id) { 0 }

      it { expect(subject.failure).to eq(errors: "Ip with id: #{id} not found") }
    end
  end

  describe 'validate' do
    let(:is_sync_enabled) { false }

    subject { described_class.resolve(:validate).call(ip: ip, is_sync_enabled: is_sync_enabled) }

    context 'when different is_sync_enabled params' do
      it { expect(subject.success).to eq(ip) }
    end

    context 'when is_sync_enabled the same as in ip' do
      let(:is_sync_enabled) { ip.is_sync_enabled }

      it { expect(subject.failure).to eq(errors: "is_sync_enabled already is #{is_sync_enabled}") }
    end
  end
end
