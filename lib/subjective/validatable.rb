# frozen_string_literal: true

require 'subjective/concernable'

module Subjective
  ##
  # Validation capabilities for a +Subjective::Context+.
  #
  # This module requires the existnece of a +#_struct_core+ instance method, which returns an object that quacks like
  # a "core" as described in {Subjective::Schemable}. Namely, it responds to +#attribute?+ and +#read_attribute+.
  #
  # In general, this module behaves much like {Subjective::Schemable}, creating and defining a "validation template"
  # using the selected strategy's DSL. It adds three instance methods: +#valid?+, +#validation_errors+, and
  # +#validation_error_messages+.
  #
  module Validatable
    extend Concernable

    attribute_spec_feature(:validators) { |attribute| schema_template.validators_for(attribute) }

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

    # @return [Boolean] +true+ if the validation template accepts the current core's attributes, +false+ otherwise
    def valid?
      _validation_template.valid?(_struct_core)
    end

    # @return [Hash<Symbol => Array<String>>] a hash or hash-like object that maps attribute names to an array of
    #   messages describing their invalid state
    def validation_errors
      _validation_template.validation_errors(_struct_core)
    end

    # @return [Array<String>] strings with user-ready strings describing all validation errors on the object
    def validation_error_messages
      _validation_template.validation_error_messages(_struct_core)
    end

    private

    def _validation_template
      self.class.validation_template
    end
  end
end
