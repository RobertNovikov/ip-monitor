# frozen_string_literal: true

require 'spec_helper'

describe Api::Ips::StatsEndpoints do
  describe 'GET /ips/:id/stats' do
    let(:app) { ::Api::IpsEndpoints }
    let!(:ip) { build(:ip, ip: '2.2.2.2', type: :ipv4).save }

    subject { get "/ips/#{ip.id}/stats" }

    it 'calls dependencies' do
      expect(::Ips::CalculateStatsInteractor).to receive(:new).and_call_original

      subject
    end
  end
end
