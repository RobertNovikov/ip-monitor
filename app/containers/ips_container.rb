# frozen_string_literal: true

# Container for ips shared logic
class IpsContainer
  extend Dry::Monads[:result]
  extend Dry::Container::Mixin

  register :find_ip, (lambda do |input|
    ip = Ip.find(id: input[:id])
    ip ? Success(ip) : Failure(errors: "Ip with id: #{input[:id]} not found")
  end)

  register :validate, (lambda do |input|
    if input[:ip].is_sync_enabled != input[:is_sync_enabled]
      Success(input[:ip])
    else
      Failure(errors: "is_sync_enabled already is #{input[:is_sync_enabled]}")
    end
  end)
end
