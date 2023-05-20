# frozen_string_literal: true

require 'spec_helper'

describe Ips::DestroyInteractor do
  let(:ip) { build(:ip, ip: '1.2.3.4', type: :ipv4).save }
  let(:id) { ip.id }

  subject { described_class.new.call(id:) }

  context 'when ip has reports' do
    let!(:availability_report) { build(:availability_report, ip_id: id).save }

    context 'when reports destroyed' do
      it { is_expected.to be_success }
    end

    context 'when has destroy errors' do
      before { allow_any_instance_of(AvailabilityReport).to receive(:destroy).and_return(false) }

      it { is_expected.to be_failure }
    end
  end

  context 'when ip without reports' do
    context 'when ip destroyed' do
      it { is_expected.to be_success }
    end

    context 'when has destroy errors' do
      before { allow_any_instance_of(Ip).to receive(:destroy).and_return(false) }

      it { is_expected.to be_failure }
    end
  end
end
