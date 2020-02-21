# frozen_string_literal: true

require 'subjective/validator_strategy'

module Subjective
  module ValidatorStrategies
    ##
    # A validation strategy for a +Subjective::Context+, used for testing purposes
    #
    class Testing < ValidatorStrategy
      class << self
        def setup!
        end
      end

      def define(dsl_block)
        dsl_block.()
      end

      def valid?(core)
        core.read_attribute(:validate_me)
      end

      def validation_errors(_core)
        {}
      end

      def validation_error_messages(_core)
        []
      end
    end
  end
end
