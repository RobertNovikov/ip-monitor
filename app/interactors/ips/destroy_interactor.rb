# frozen_string_literal: true

module Ips
  class DestroyInteractor
    prepend InteractorWithContract

    option :find_item, reader: :private, default: -> { ::IpsContainer.resolve(:find_ip) }

    contract do
      required(:id).filled(:integer)
    end

    def call(id:)
      ip = yield find_item.(id: id)
      yield destroy_associations(ip)
      destroy(ip)
    end

    private

    def destroy_associations(ip)
      ip.availability_reports_dataset.order(:id).paged_each do |availability_report|
        return Failure(availability_report.errors) unless availability_report.destroy
      end
      Success(ip)
    end

    def destroy(ip)
      ip.destroy ? Success(ip: ip) : Failure(ip.errors)
    end
  end
end
