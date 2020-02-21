# frozen_string_literal: true

require 'subjective/concernable'

module Subjective
  ##
  # Validation capabilities for a +Subjective::Context+.
  #
  module Validatable
    extend Concernable

    # Macros for validations
    module ClassMethods
      def define_validations(&dsl)
        validation_template.define(dsl)
      end

      def validation_template
        @validation_template ||= validator_strategy.new
      end

      private

      def validator_strategy
        Subjective.validator_strategy
      end
    end
  end
end
