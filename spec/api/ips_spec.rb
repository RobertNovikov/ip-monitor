# frozen_string_literal: true

require 'spec_helper'

describe Api::Ips do
  describe 'GET /ips/:id/stats' do
    let(:app) { described_class }
    let(:ip_address) { '2.2.2.2' }
    let!(:ip) { build(:ip, ip: ip_address, type: :ipv4).save }

    subject { get "/ips/#{ip.id}/stats" }

    it 'returns correct data' do
      subject

      expect(last_response.body).to eq('{"error":"statistics not found"}')
    end
  end
end
