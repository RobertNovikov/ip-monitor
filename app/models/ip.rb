# frozen_string_literal: true

# Model for ips table
class Ip < Sequel::Model(DB)
  one_to_many :availability_reports

  plugin :enum
  enum :type, ipv4: 0, ipv6: 1

  plugin :validation_helpers
  def validate
    super
    validates_presence %i[ip type]
  end
end
