# frozen_string_literal: true

require 'set'

require 'subjective/seed_name_index'

module Subjective
  class SeedNotFoundError < StandardError; end

  # @private
  class SeedCollection
    include Enumerable

    def initialize(name_index: SeedNameIndex.new, type_index: Subjective::Seedable.seed_type_index)
      @name_index = name_index
      @type_index = type_index
    end

    def each
      return enum_for(:each) unless block_given?

      seeds.each { |seed| yield seed }
    end

    def empty?
      seeds.empty?
    end

    def <<(seed)
      verify_new_seed!(seed)

      indexes.each { |index| index.add_seed(seed) }

      seeds << seed
    end

    def find(keys)
      name_index.find_seed_for_names(keys)
    end

    private

    attr_reader :name_index, :type_index

    def indexes
      [name_index, type_index]
    end

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
