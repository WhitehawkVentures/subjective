# frozen_string_literal: true

require 'subjective/version'
require 'subjective/context'

##
# = Subjective
#
module Subjective
  STRUCT_STRATEGIES = {
    testing: 'StructStrategies::Testing',
    dry_struct: 'StructStrategies::DryStruct'
  }.freeze

  VALIDATOR_STRATEGIES = {
    testing: 'ValidatorStrategies::Testing',
    activemodel: 'ValidatorStrategies::ActiveModel'
  }.freeze

  class << self
    attr_accessor :struct_strategy, :validator_strategy

    def use(strategy)
      self.struct_strategy = find_struct_strategy(strategy)
      struct_strategy.setup!
    end

    def validate_with(strategy)
      self.validator_strategy = find_validator_strategy(strategy)
      validator_strategy.setup!
    end

    def available_seeds_for(objects)
      Subjective::Seedable.seed_type_index.find_seeds_for_objects(objects)
    end

    private

    def find_struct_strategy(strategy)
      require "subjective/struct_strategies/#{strategy}"

      const_get STRUCT_STRATEGIES[strategy.to_sym]
    end

    def find_validator_strategy(strategy)
      require "subjective/validator_strategies/#{strategy}"

      const_get VALIDATOR_STRATEGIES[strategy.to_sym]
    end
  end
end
