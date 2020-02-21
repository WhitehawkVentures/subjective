# frozen_string_literal: true

require 'subjective/validator_strategy'

module Subjective
  module ValidatorStrategies
    ##
    # The +ActiveModel::Validations+ strategy for validation a +Subjective::Context+.
    #
    class ActiveModel < ValidatorStrategy
      class << self
        def setup!
          require 'active_model'
        end
      end

      def define(dsl_block)
        validation_model.class_eval(&dsl_block)
      end

      def valid?(core)
        validation_instance(core).valid?
      end

      def validation_errors(core)
        validation_instance(core).errors
      end

      def validation_error_messages(core)
        validation_instance(core).errors.full_messages
      end

      private

      def validation_instance(core)
        instance = validation_model.new(core)

        instance.validate

        instance
      end

      # rubocop:disable Metrics/MethodLength
      def validation_model
        @validation_model ||=
          begin
            result = Class.new do
              include ::ActiveModel::Validations

              attr_reader :core

              class << self
                attr_accessor :name
              end

              def initialize(core)
                @core = core
              end

              def method_missing(method_name, *args)
                core.attribute?(method_name) ? core.read_attribute(method_name) : super
              end

              def respond_to_missing?(method_name, *args)
                core.attribute?(method_name) || super
              end
            end

            result.name = context_klass.name

            result
          end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
