# frozen_string_literal: true

require 'ostruct'

module Subjective
  module StructStrategies
    ##
    # A struct strategy for the purposes of testing.
    #
    class Testing < StructStrategy
      class << self
        def setup!(_base_context_klass)
        end
      end

      def define(dsl_block)
        dsl_block.()
      end

      def default_attributes
        {}
      end

      def create_core(attributes = {})
        CoreWrapper.new(attributes)
      end

      def attribute?(_attribute_name)
        true
      end

      def type_for(_attribute_name)
        String
      end

      def default_for(_attribute_name)
        'Testing!'
      end

      def optional_for(_attribute_name)
        true
      end

      # @private
      class CoreWrapper
        def initialize(attributes)
          @instance = OpenStruct.new(attributes)
        end

        def attribute?(attribute_name)
          instance.to_h.key?(attribute_name.to_sym)
        end

        def read_attribute(attribute_name)
          instance.public_send(attribute_name)
        end

        private

        attr_reader :instance
      end
    end
  end
end
