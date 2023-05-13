# frozen_string_literal: true

module Api
  # Api methods for managing ip addresses
  class Ips < ::Grape::API
    prefix 'ips'
    format :json

    helpers do
      def find_ip
        @ip = Ip.find(id: params[:id])
      end

      def statistics_present?
        scope = @ip.availability_reports_dataset
        scope = scope.where { created_at > params[:time_from] } if params[:time_from]
        scope = scope.where { created_at > params[:time_to] } if params[:time_to]
        scope.present?
      end
    end

    params do
      optional :time_from, type: String, desc: 'From what time to calculate statistics'
      optional :time_to, type: Boolean, desc: 'Until what time to calculate statistics'
    end
    get ':id/stats' do
      find_ip
      return { error: 'ip not found' } unless @ip
      return { error: 'statistics not found' } unless statistics_present?

      query = AvailabilityStatsQuery.new(
        ip_id: @ip.id, time_from: params[:time_from], time_to: params[:time_to]
      ).call

      query.first
    end

    params do
      requires :ip, type: String, desc: 'Ipv4/ipv6 address'
      optional :enabled, type: Boolean, desc: 'Enable/disable ip synchronization'
    end
    post do
      ip = begin
        IPAddress params[:ip]
      rescue ArgumentError
        nil
      end

      return { error: "Invalid IP address: #{params[:ip]}" } unless ip

      ip = Ip.new(
        ip:,
        is_sync_enabled: params[:enabled] || false,
        type: ip.ipv4? ? :ipv4 : :ipv6
      )

      ip.save ? { success: true } : ip.errors
    end

    post ':id/enable' do
      find_ip
      return { error: 'ip not found' } unless @ip

      @ip.update(is_sync_enabled: true) unless @ip.is_sync_enabled
      @ip.valid? ? { success: true } : @ip.errors
    end

    post ':id/disable' do
      find_ip
      return { error: 'ip not found' } unless @ip

      @ip.update(is_sync_enabled: false) if @ip.is_sync_enabled
      @ip.valid? ? { success: true } : @ip.errors
    end

    delete ':id' do
      find_ip
      return { error: 'ip not found' } unless @ip

      @ip.destroy ? { success: true } : @ip.errors
    end
  end
end
