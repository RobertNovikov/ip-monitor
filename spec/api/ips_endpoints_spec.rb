# frozen_string_literal: true

require 'spec_helper'

describe Api::IpsEndpoints do
  describe 'POST /ips' do
    let(:app) { described_class }
    let(:params) { { ip: '1.2.3.4', enabled: true } }

    subject { post '/ips', params.to_json, 'CONTENT_TYPE' => 'application/json' }

    it 'calls dependencies' do
      expect(::Ips::CreateInteractor).to receive(:new).and_call_original

      subject
    end
  end

  describe 'POST /ips/:id/enable' do
    let(:app) { described_class }
    let!(:ip) { build(:ip, ip: '2.2.2.2', type: :ipv4, is_sync_enabled: false).save }

    subject { post "/ips/#{ip.id}/enable" }

    it 'calls dependencies' do
      expect(::Ips::UpdateInteractor).to receive(:new).and_call_original

      subject
    end
  end

  describe 'POST /ips/:id/disable' do
    let(:app) { described_class }
    let!(:ip) { build(:ip, ip: '2.2.2.2', type: :ipv4, is_sync_enabled: true).save }

    subject { post "/ips/#{ip.id}/disable" }

    it 'calls dependencies' do
      expect(::Ips::UpdateInteractor).to receive(:new).and_call_original

      subject
    end
  end

  describe 'DELETE /ips/:id' do
    let(:app) { described_class }
    let!(:ip) { build(:ip, ip: '2.2.2.2', type: :ipv4).save }

    subject { delete "/ips/#{ip.id}" }

    it 'calls dependencies' do
      expect(::Ips::DestroyInteractor).to receive(:new).and_call_original

      subject
    end
  end
end
