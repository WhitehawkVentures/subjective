# frozen_string_literal: true

require 'set'

module Subjective
  # @private
  class SeedCollection
    include Enumerable

    def each
      return enum_for(:each) unless block_given?

      seeds.each { |seed| yield seed }
    end

    def empty?
      seeds.empty?
    end

    def <<(seed)
      verify_new_seed! seed

      seeds << seed
    end

    private

    def seeds
      @seeds ||= Set.new
    end

    def verify_new_seed!(seed)
      raise ArgumentError, 'Cannot have more than one seed with the same keys' if seed_exists?(seed)
    end

    def seed_exists?(subject)
      seeds.any? { |seed| seed.matches_keys?(subject) }
    end
  end
end
