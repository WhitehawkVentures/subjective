# frozen_string_literal: true

require 'subjective/concernable'
require 'subjective/seed'
require 'subjective/seed_collection'

module Subjective
  ##
  # Data seeding capabilities for a +Subjective::Context+.
  #
  module Seedable
    extend Concernable

    # Macros for seeding
    module ClassMethods
      # @raise [ArgumentError] if there exists a seed with the same keys
      def seed_with(**seed_types, &seed_config)
        seeds << new_seed(seed_types, &seed_config)
      end

      def materialize_with(**seed_data)
      end

      def seeds
        @seeds ||= SeedCollection.new
      end

      private

      def new_seed(seed_types, &seed_config)
        Seed.new(seed_types, self, &seed_config)
      end
    end
  end
end
