# frozen_string_literal: true

# Serialize ip model
class IpSerializer
  include JSONAPI::Serializer

  attributes :id, :ip, :type, :is_sync_enabled
end
