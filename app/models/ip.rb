# frozen_string_literal: true

# Model for ips table
class Ip < Sequel::Model(DB)
  plugin :enum
  enum :type, ipv4: 0, ipv6: 1
end
