# frozen_string_literal: true

module Api
  # Api methods for managing ip addresses
  class Ips < ::Grape::API
    prefix 'ips'
    format :json

    get ':id/stats' do
      { ip: Ip[params[:id]]&.ip, current_time: Time.now.strftime('%Y-%m-%d %H:%M:%S') }
    end

    post do
      { method: 'post', current_time: Time.now.strftime('%Y-%m-%d %H:%M:%S') }
    end

    post ':id/enable' do
      { method: 'post enable', current_time: Time.now.strftime('%Y-%m-%d %H:%M:%S') }
    end

    post ':id/disable' do
      { method: 'post disable', current_time: Time.now.strftime('%Y-%m-%d %H:%M:%S') }
    end

    delete ':id' do
      { method: 'delete', current_time: Time.now.strftime('%Y-%m-%d %H:%M:%S') }
    end
  end
end
