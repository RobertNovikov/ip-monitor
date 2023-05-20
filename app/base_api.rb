# frozen_string_literal: true

# Describes api scheme
class BaseApi < Grape::API
  mount Api::IpsEndpoints => 'ips'
  add_swagger_documentation format: :json, add_root: true
end
