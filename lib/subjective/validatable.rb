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
        @validation_template ||= validator_strategy.new(self)
      end

      private

      def validator_strategy
        Subjective.validator_strategy
      end
    end

    def valid?
      _validation_template.valid?(_struct_core)
    end

    def validation_errors
      _validation_template.validation_errors(_struct_core)
    end

    def validation_error_messages
      _validation_template.validation_error_messages(_struct_core)
    end

    private

    def _validation_template
      self.class.validation_template
    end
  end
end
