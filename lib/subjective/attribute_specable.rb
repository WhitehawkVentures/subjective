# frozen_string_literal: true

require 'subjective/attribute_spec'

module Subjective
  ##
  # Configuration options for an attribute spec.
  #
  module AttributeSpecable
    # @return [AttributeSpec] a hash-like object containing various convenient information about a given attribute
    def attribute_spec
      @attribute_spec ||= AttributeSpec.new(self)
    end

    # @private
    def add_attribute_spec_features!(features)
      features.each { |feature| AttributeSpec.add_feature!(feature[:name], feature[:getter]) }
    end
  end
end
