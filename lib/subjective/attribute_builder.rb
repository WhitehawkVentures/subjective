# frozen_string_literal: true

module Subjective
  ##
  # @private
  #
  class AttributeBuilder
    class << self
      def build(*args)
        new(*args).build
      end
    end

    attr_reader :config, :opts

    def initialize(config, opts = {})
      @config = config
      @opts = opts
    end

    def build
      schema
    end

    private

    def schema
      @schema ||= Subjective::Attribute.new(config)
    end
  end
end

require 'subjective/attribute'
