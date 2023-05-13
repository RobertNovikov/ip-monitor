# frozen_string_literal: true

# Model for ips table
class AvailabilityReport < Sequel::Model(DB)
  many_to_one :ips

  plugin :validation_helpers
  def validate
    super
    validates_presence %i[ip_id]
  end
end
