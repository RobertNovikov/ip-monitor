# frozen_string_literal: true

module Ips
  # updates ip
  class UpdateInteractor
    prepend InteractorWithContract

    option :find_item, reader: :private, default: -> { ::IpsContainer.resolve(:find_ip) }
    option :validate, reader: :private, default: -> { ::IpsContainer.resolve(:validate) }

    contract do
      required(:id).filled(:integer)
      required(:is_sync_enabled).filled(:bool)
    end

    def call(id:, is_sync_enabled:)
      ip = yield find_item.call(id:)
      yield validate.call(ip:, is_sync_enabled:)
      update(ip, is_sync_enabled)
    end

    private

    def update(ip, is_sync_enabled)
      ip.update(is_sync_enabled:) ? Success(ip:) : Failure(errors: ip.errors)
    end
  end
end
