# frozen_string_literal: true

module Subjective
  ##
  # @private
  #
  class Attribute
    def initialize(config)
      instance_eval(&config) if config
    end

    def getter(&generator)
      @getter = generator
    end

    def type(type_name)
      extend type_mixin_for(type_name)
    end

    private

    def type_mixin_for(type_name)
      Types.lookup(type_name)
    end
  end
end

require 'subjective/types'
