# frozen_string_literal: true

module Ips
  class CalculateStatsInteractor
    prepend InteractorWithContract

    option :find_item, reader: :private, default: -> { ::IpsContainer.resolve(:find_ip) }

    contract do
      required(:id).filled(:integer)
      optional(:time_from).maybe { str? & format?(/^\d{2}\/\d{2}\/\d{4}\s\d{2}:\d{2}$/)}
      optional(:time_to).maybe { str? & format?(/^\d{2}\/\d{2}\/\d{4}\s\d{2}:\d{2}$/)}
    end

    def call(id:, time_from:, time_to:)
      ip = yield find_item.(id: id)
      yield statistics_present?(ip, time_from, time_to)
      calculate(ip, time_from, time_to)
    end

    private

    def statistics_present?(ip, time_from, time_to)
      scope = ip.availability_reports_dataset
      scope = scope.where { created_at > time_from } if time_from
      scope = scope.where { created_at < time_to } if time_to
      scope.present? ? Success(ip:, time_from:, time_to:) : Failure(errors: "Statistics not found")
    end

    def calculate(ip, time_from, time_to)
      stats_query = AvailabilityStatsQuery.new(ip_id: ip.id, time_from:, time_to:).call
      Success(stats_query.first)
    end
  end
end
