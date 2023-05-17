# frozen_string_literal: true

require 'spec_helper'

describe IpSerializer do
  let(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4, is_sync_enabled: true).save }
  let(:expected_result) do
    {
      id: ip.id,
      ip: ip.ip,
      type: ip.type,
      is_sync_enabled: ip.is_sync_enabled
    }
  end

  subject { described_class.new(ip).serializable_hash.dig(:data, :attributes) }

  it { is_expected.to eq(expected_result) }
end
