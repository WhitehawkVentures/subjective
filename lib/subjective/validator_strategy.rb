# frozen_string_literal: true

module Subjective
  ##
  # Base class for validator strategies.
  #
  class ValidatorStrategy
    attr_reader :context_klass

    def initialize(context_klass)
      @context_klass = context_klass
    end
  end
end
