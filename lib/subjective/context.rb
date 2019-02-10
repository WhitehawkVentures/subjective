# frozen_string_literal: true

require 'subjective/attributable'

module Subjective
  ##
  # Base class and DSL for a context container.
  #
  class Context
    extend Subjective::Attributable

    attr_reader :params

    def initialize(params = {})
      @params = params
    end
  end
end
