# frozen_string_literal: true

module Subjective
  ##
  # Base class and DSL for a context container.
  #
  class Context
    attr_reader :params

    class << self
      def define_schema(&dsl)
        struct_template.define(dsl)
      end

      def define_validations(&dsl)
        validation_template.define(dsl)
      end

      def seed_with(**seed_types, &seed_config)
        seeds << new_seed(seed_types, seed_config)
      end

      def materialize_with(**seeds)
      end

      def struct_template
        @struct_template ||= struct_strategy.new
      end

      def validation_template
        @validation_template ||= validator_strategy.new
      end

      private

      def struct_strategy
        Subjective.struct_strategy
      end

      def validator_strategy
        Subjective.validator_strategy
      end
    end

    def initialize(params = {})
      @_struct_core = struct_template.create_core(params)
    end

    def method_missing(method_name, *args)
      _struct_core.attribute?(method_name) ? _struct_core.read_attribute(method_name, *args) : super
    end

    def respond_to_missing?(method_name, *args)
      _struct_core.attribute?(method_name) || super
    end

    private

    attr_reader :_struct_core

    def struct_template
      self.class.struct_template
    end
  end
end
