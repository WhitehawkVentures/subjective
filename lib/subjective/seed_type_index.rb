# frozen_string_literal: true

require 'set'

module Subjective
  # @private
  class SeedTypeIndex < Hash
    def initialize
      super(&proc { |h, k| h[k] = [] })
    end

    def add_seed(seed)
      self[seed_key(seed.types)] << seed
    end

    def find_seeds_for_objects(objects)
      find_seeds_for_types objects.map(&:class)
    end

    def find_seeds_for_types(types)
      keys.each_with_object([]) { |key, result| result.concat(self[key]) if types_cover_key?(types, key) }
    end

    private

    def seed_key(types)
      types.to_set
    end

    def types_cover_key?(types, key)
      permutations = key.to_a.permutation(key.length).to_a

      permutations.each do |permutation|
        permutation = permutation.dup

        types.each { |type| permutation.delete_if { |element| type <= element } }

        return true if permutation.empty?
      end

      false
    end
  end
end
