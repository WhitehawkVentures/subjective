# frozen_string_literal: true

module Subjective
  ##
  # @private
  #
  module Attributable
    def attribute(name, getter = nil, **opts, &config)
      opts = opts.merge(getter: getter) if getter
      attribute_data[name] = attribute_schema_for(config, opts)
    end

    def attribute_data
      @attribute_data ||= {}
    end

    private

    def attribute_schema_for(config, opts)
      Subjective::AttributeBuilder.build(config, opts)
    end
  end
end

require 'subjective/attribute_builder'
