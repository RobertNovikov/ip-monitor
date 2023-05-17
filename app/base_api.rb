# frozen_string_literal: true

# Describes api scheme
class BaseApi < Grape::API
  mount Api::IpsEndpoints
end
