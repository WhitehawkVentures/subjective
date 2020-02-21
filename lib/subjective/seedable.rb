# frozen_string_literal: true

require 'subjective/concernable'

module Subjective
  ##
  # Data seeding capabilities for a +Subjective::Context+.
  #
  module Seedable
    extend Concernable

    # Macros for seeding
    module ClassMethods
      def seed_with(**seed_types, &seed_config)
        seeds << new_seed(seed_types, seed_config)
      end

      def materialize_with(**seeds)
      end
    end
  end
end
