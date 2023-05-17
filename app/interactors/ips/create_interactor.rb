# frozen_string_literal: true

module Ips
  class CreateInteractor
    prepend InteractorWithContract

    contract do
      required(:ip).filled(:string)
      optional(:enabled).maybe(:bool)
    end

    def call(ip:, enabled:)
      ip_object = yield validate(ip)
      create(ip_object, enabled)
    end

    private

    def validate(ip)
      ip = begin
        IPAddress ip
      rescue ArgumentError
        nil
      end

      ip ? Success(ip) : Failure(error: "Invalid IP address: #{ip}")
    end

    def create(ip, enabled)
      ip_for_save = Ip.new(
        ip:,
        is_sync_enabled: enabled,
        type: ip.ipv4? ? :ipv4 : :ipv6
      )

      ip_for_save.save ? Success(ip: ip_for_save) : Failure(ip_for_save.errors)
    end
  end
end
