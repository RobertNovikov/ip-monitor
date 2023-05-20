# frozen_string_literal: true

require 'spec_helper'

describe Ips::UpdateInteractor do
  let(:initial_is_sync_enabled) { true }
  let(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4, is_sync_enabled: initial_is_sync_enabled).save }
  let(:id) { ip.id }
  let(:is_sync_enabled_param) { false }

  subject { described_class.new.call(id:, is_sync_enabled: is_sync_enabled_param) }

  context 'when ip updated' do
    it { is_expected.to be_success }
  end

  context 'when has update errors' do
    before { allow_any_instance_of(Ip).to receive(:update).and_return(false) }

    it { is_expected.to be_failure }
  end
end
