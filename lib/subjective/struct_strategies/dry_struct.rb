# frozen_string_literal: true

module Subjective
  module StructStrategies
    ##
    # The +dry-struct+ struct strategy for a subjective context.
    #
    class DryStruct < StructStrategy
      class << self
        def setup!
          require 'dry-struct'
        end
      end

      def define(dsl_block)
        dsl_target.class_eval(&dsl_block)
      end

      def dsl_target
        @dsl_target ||= Class.new(Dry::Struct)
      end

      def create_core(attributes = {})
        CoreWrapper.new(dsl_target, attributes)
      end

      ##
      # @private
      #
      class CoreWrapper
        def initialize(core_klass, attribute_assignments)
          @core_klass = core_klass
          @attribute_assignments = attribute_assignments
        end

        def instance
          @instance ||= new_instance
        end

        def attribute?(attribute_name)
          core_klass.has_attribute?(attribute_name)
        end

        def read_attribute(attribute_name)
          instance.public_send(attribute_name)
        end

        private

        attr_reader :core_klass, :attribute_assignments

        def new_instance
          core_klass.new(attribute_assignments)
        end
      end
    end
  end
end
