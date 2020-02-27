# frozen_string_literal: true

module Subjective
  # @private
  class SeedNameIndex < Hash
    def add_seed(seed)
      self[seed_key(seed.keys)] = seed
    end

    def find_seed_for_names(names)
      self[seed_key(names)]
    end

    private

    def seed_key(names)
      names.map(&:to_s).sort.join('//').to_sym
    end
  end
end
