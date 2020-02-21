# frozen_string_literal: true

module Subjective
  ##
  # @private
  #
  module Concernable
    def included(base)
      base.extend(const_get(:ClassMethods)) if const_defined?(:ClassMethods)

      base.add_attribute_spec_features!(attribute_spec_features) if base.respond_to?(:add_attribute_spec_features!)
    end

    def attribute_spec_feature(feature_name, &getter)
      attribute_spec_features << { name: feature_name, getter: getter }
    end

    private

    def attribute_spec_features
      @attribute_spec_features ||= []
    end
  end
end
