# frozen_string_literal: true

require 'set'

module Subjective
  class SeedNotFoundError < StandardError; end

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

      name_map[name_map_key(seed.keys)] = seed
      seeds << seed
    end

    def find(keys)
      name_map[name_map_key(keys)]
    end

    private

    def seeds
      @seeds ||= Set.new
    end

    def name_map
      @name_map ||= {}
    end

    def name_map_key(keys)
      keys.map(&:to_s).sort.join('//').to_sym
    end

    def verify_new_seed!(seed)
      raise ArgumentError, 'Cannot have more than one seed with the same keys' if seed_exists?(seed)
    end

    def seed_exists?(subject)
      seeds.any? { |seed| seed.matches_keys?(subject) }
    end
  end
end
