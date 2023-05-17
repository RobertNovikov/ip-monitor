# frozen_string_literal: true

require 'dry/monads/do'
require 'dry/matcher/result_matcher'

class ContractError < StandardError; end

# Base implementation of interactor with contract check
module InteractorWithContract
  def self.prepended(base)
    base.extend ClassMethods
    base.extend Dry::Initializer
    base.include Dry::Monads[:result, :do]
    base.include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
  end

  def call(*args)
    return super(*args) if args.blank?
    return contract_error('Call args are to big. Allowed only one parameter') if args.size != 1

    options = args.first
    contract = self.class.contract_object
    contract_error('Contract is not filled') if contract.blank?
    contract_params = fetch_contract_params(contract)
    check_params_in_args(contract_params, options.keys)

    contract_result = contract.call(options)
    return Failure(contract_result.errors.to_h) if contract_result.failure?

    super(**options)
  end

  def check_params_in_args(contract_params, args_params)
    missed_params = args_params - contract_params
    return if missed_params.empty?

    contract_error("Input params (#{missed_params}) are not present in contract")
  end

  def fetch_contract_params(contract)
    schema = contract.is_a?(Dry::Schema::Params) ? contract : contract.schema

    schema.key_map.keys.map(&:name).map(&:to_sym)
  end

  def contract_error(msgs)
    raise ContractError.new(source: self.class, msgs: Array.wrap(msgs).join('; '))
  end

  # Interactor class methods
  module ClassMethods
    attr_accessor :contract_object

    def contract(kind = :common, &block)
      case kind
      when :common
        @contract_object = Dry::Schema.Params(&block)
      when :smart
        @contract_object = Dry::Validation::Contract(&block)
      else
        raise ArgumentError
      end
    end
  end
end
