# frozen_string_literal: true

module Subjective
  ##
  # A hash-like object that contains various information about a given attribute. Has a set of **features** that can be
  # added.
  #
  class AttributeSpec
    class << self
      def add_feature!(feature_name, getter)
        features[feature_name.to_sym] = getter
      end

      def features
        @features ||= {}
      end
    end

    attr_reader :base

    def initialize(base)
      @base = base
    end

    def [](attribute_name)
      return nil unless base.attribute?(attribute_name)

      attribute_name = attribute_name.to_sym

      Attribute.new(base, attribute_name)
    end

    # @private
    class Attribute
      attr_reader :base, :name

      def initialize(base, name)
        @base = base
        @name = name
      end

      def method_missing(method_name, *args)
        feature_getters[method_name.to_sym] ? read_feature(method_name) : super
      end

      def respond_to_missing?(method_name, *args)
        !!feature_getters[method_name.to_sym] || super
      end

      protected

      def feature_getters
        AttributeSpec.features
      end

      private

      def read_feature(feature_name)
        base.class_exec(name, &feature_getters[feature_name.to_sym])
      end
    end
  end
end
