# frozen_string_literal: true

module Api
  module Ips
    # Api methods for getting statistics of ip addresses
    class StatsEndpoints < ::Grape::API
      format :json

      params do
        optional :time_from, type: String, desc: 'Start time in format mm/dd/yyyy hh:mm'
        optional :time_to, type: Boolean, desc: 'End time in format mm/dd/yyyy hh:mm'
      end
      get ':id/stats' do
        ::Ips::CalculateStatsInteractor.new.(
          id: params[:id],
          time_from: params[:time_from],
          time_to: params[:time_to]
        ) do |interactor|
          interactor.success { |result| result }
          interactor.failure { |errors| errors }
        end
      end
    end
  end
end
