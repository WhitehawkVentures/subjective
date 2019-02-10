# frozen_string_literal: true

require 'subjective/types/object'

module Subjective
  ##
  # @private
  #
  module Types
    MIXINS = {
      object: Subjective::Types::Object
    }.freeze

    class << self
      def lookup(name)
        MIXINS[name]
      end
    end
  end
end
