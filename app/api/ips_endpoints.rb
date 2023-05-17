# frozen_string_literal: true

module Api
  # Api methods for managing ip addresses
  class IpsEndpoints < ::Grape::API
    prefix 'ips'
    format :json

    mount Api::Ips::StatsEndpoints

    params do
      requires :ip, type: String, desc: 'Ipv4/ipv6 address'
      optional :enabled, type: Boolean, desc: 'Enable/disable ip synchronization'
    end
    post do
      ::Ips::CreateInteractor.new.(ip: params[:ip], enabled: params[:enabled]) do |interactor|
        interactor.success { |result| ::IpSerializer.new(result[:ip]).serializable_hash.dig(:data, :attributes) }
        interactor.failure { |errors| errors }
      end
    end

    post ':id/enable' do
      ::Ips::UpdateInteractor.new.(id: params[:id], is_sync_enabled: true) do |interactor|
        interactor.success { |result| { success: "Ip with id '#{result[:ip].id} successfully enabled" } }
        interactor.failure { |errors| errors }
      end
    end

    post ':id/disable' do
      ::Ips::UpdateInteractor.new.(id: params[:id], is_sync_enabled: false) do |interactor|
        interactor.success { |result| { success: "Ip with id '#{result[:ip].id} successfully disabled" } }
        interactor.failure { |errors| errors }
      end
    end

    delete ':id' do
      ::Ips::DestroyInteractor.new.(id: params[:id]) do |interactor|
        interactor.success { |result| { success: "Ip with id '#{result[:ip].id} successfully deleted" } }
        interactor.failure { |errors| errors }
      end
    end
  end
end
