# frozen_string_literal: true

require 'subjective/concernable'

module Subjective
  ##
  # Schema capabilities for a +Subjective::Context+.
  #
  module Schemable
    extend Concernable

    attribute_spec_feature(:type) { |attribute| schema_template.type_for(attribute) }
    attribute_spec_feature(:default) { |attribute| schema_template.default_for(attribute) }
    attribute_spec_feature(:optional?) { |attribute| schema_template.optional_for(attribute) }

    # Macros for schema-related capabilities
    module ClassMethods
      def define_schema(&dsl)
        schema_template.define(dsl)
      end

      def schema_template
        @schema_template ||= struct_strategy.new
      end

      def attribute?(attribute_name)
        schema_template.attribute?(attribute_name)
      end

      private

      def struct_strategy
        Subjective.struct_strategy
      end
    end

    def method_missing(method_name, *args)
      _struct_core.attribute?(method_name) ? _struct_core.read_attribute(method_name, *args) : super
    end

    def respond_to_missing?(method_name, *args)
      _struct_core.attribute?(method_name) || super
    end

    private

    attr_reader :_struct_core

    def _schema_template
      self.class.schema_template
    end
  end
end
