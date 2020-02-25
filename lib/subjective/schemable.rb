# frozen_string_literal: true

require 'subjective/concernable'

module Subjective
  ##
  # Defines a schema based on +Subjective+'s selected "struct strategy," wrapping the strategy's DSL, translating the
  # configuration into something more universal. Exposes various features, such as a type, default values, etc., in the
  # attribute sepc if applicable.
  #
  # === How it works
  #
  # In this section, we will refer to the including class simply as +self+, for brevity's sake. Each class that
  # includes {Subjective::Schemable} has an instance of the "struct strategy" defined by {Subjective}'s initialization
  # logic. This instance is called the "schema template," and contains the definitions for all of the including class's
  # attributes.
  #
  # Instances of +self+ each contains a "core" (referenced by the instance variable +@_struct_core+), which contains
  # values for each of its attributes. It is up to +self+ to set up initialization logic (see {Subjective::Context} for
  # the canonical example), but the core can be initialized by calling +.create_core+ on the +_schema_template+ (which
  # delegates to +self+'s +schema_template+ variable). A {Subjective::Context} calls this in its constructor.
  #
  #   @_struct_core = _schema_template.create_core(name: 'Bob', age: 20)
  #
  # The core's values can be accessed via its +read_attribute+ method.
  #
  #   _struct_core.read_attribute(:name) #=> 'Bob'
  #
  # This module also introduces dynamic methods for each of the core's attributes. For instance, if the core has the
  # attribute +name+ (i.e., it responds with +true+ if we ask it +_struct_core.attribute?(:name)+), then we get a
  # method +#name+ on instances of +self+.
  #
  #   instance_of_self.name #=> 'Bob'
  #
  module Schemable
    extend Concernable

    attribute_spec_feature(:type) { |attribute| schema_template.type_for(attribute) }
    attribute_spec_feature(:default) { |attribute| schema_template.default_for(attribute) }
    attribute_spec_feature(:optional?) { |attribute| schema_template.optional_for(attribute) }

    # Macros for schema-related capabilities
    module ClassMethods
      # Configure the schema template for the provided "struct strategy."
      def define_schema(&dsl)
        schema_template.define(dsl)
      end

      # @return [Subjective::StructStrategy] the schema configured for +self+
      def schema_template
        @schema_template ||= struct_strategy.new
      end

      # Asks if the provided attribute name is configured in the schema.
      #
      # @param attribute_name [#to_sym] the name of the attribute we are inquiring about
      # @return [Boolean] +true+ if the schema template has the attribute configured for instances of +self+, +false+
      #   otherwise
      def attribute?(attribute_name)
        schema_template.attribute?(attribute_name)
      end

      private

      def struct_strategy
        Subjective.struct_strategy
      end
    end

    def method_missing(method_name, *args)
      attribute?(method_name) ? _struct_core.read_attribute(method_name, *args) : super
    end

    def respond_to_missing?(method_name, *args)
      attribute?(method_name) || super
    end

    private

    attr_reader :_struct_core

    def attribute?(attribute_name)
      self.class.attribute?(attribute_name)
    end

    def _schema_template
      self.class.schema_template
    end
  end
end
