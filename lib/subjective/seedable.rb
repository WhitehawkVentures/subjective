# frozen_string_literal: true

require 'subjective/concernable'
require 'subjective/seed'
require 'subjective/seed_collection'

module Subjective
  ##
  # Data seeding capabilities for a +Subjective::Context+.
  #
  # === Terminology
  #
  # A **seed template** is a mapping of a set of _names_ onto _types_. This allows us to find available seeds based on
  # input data.
  #
  #   { user: User, product: Product }
  #
  # A **seed config** is a proc containing the "materialization DSL." This will map the template's keys onto the
  # context's attributes.
  #
  #   proc do
  #     name { "#{user.first_name} #{user.last_name}" }
  #     price { product.price }
  #   end
  #
  # **Seed data** refers to a hash mapping a corresponding seed template's _names_ onto actual objects. With this data,
  # we can materialize a seed, yielding an instance of the including class.
  #
  #   { user: some_user, product: some_product }
  #
  # === Usage
  #
  # Use {Subjective::Seedable::ClassMethods#seed_with} to register a seed, providing a tempalte and a config.
  #
  # Note: The including class must quack like a {Subjective::Schemable} -- that is, its constructor must accept keyword
  # arguments for each attribute referenced by the +Seedable+ DSL, and the class must respond to +.attribute?+, which
  # takes a symbol and returns true or false depending on if instances have that attribute.
  #
  #   class Thing
  #     include Subjective::Seedable
  #
  #     seed_with(user: User, product: Product) do
  #       name { "#{user.first_name} #{user.last_name}" }
  #       price { product.price }
  #     end
  #
  #     # ...
  #   end
  #
  # We can then take some seed data and use it to create an instance of our class.
  #
  #   Thing.materialize_with(user: some_user, product: some_product)
  #
  module Seedable
    extend Concernable

    # Macros for seeding
    module ClassMethods
      # Create a new seed with a template and a config block. The keys passed in as the template will become methods
      # accessible from the blocks passed in to the materialization DSL. The DSL works like this: each attribute (i.e.,
      # each value for which the including class's +attribute?+ method will return false) is defined as a method. Each
      # of these methods takes another block, which should return the mapped value for that attribute. Each inner block
      # has a method named after each key in the provided seed template, which will return the as-yet-undetermined seed
      # data value for that key.
      #
      #   seed_with(article: Article, author: Author) do # `article` and +author+ will be available in the inner blocks
      #     draft_title { "DRAFT: #{article.title}" } # `title` is an attribute on the parent class
      #   end
      #
      # If we materialize the above seed with an article whose +title+ is +'The Lord of the Rings'+, then the resulting
      # context's +draft_title+ attribute will be +'DRAFT: The Lord of the Rings'+.
      #
      # @param seed_template [Hash<Symbol => Class>] a mapping of names onto types, expressing the expected data
      #   structures involved with this seed. These will be accessible as first-class properties in the DSL. See this
      #   method's description for more information.
      # @param seed_config [Proc] a block that calls the "materialization DSL," defining how +self+'s attributes should
      #   be mapped from the seed data.
      # @raise [ArgumentError] if there exists a seed with the same keys
      def seed_with(**seed_template, &seed_config)
        seeds << new_seed(seed_template, &seed_config)
      end

      # Create an instance of +self+ using seed data associated with a pre-defined seed.
      #
      # (Using the example illustrated in {Subjective::Seedable::ClassMethods#seed_with}):
      #
      #   ctx = ThisThing.materialize_with(article: some_article, author: some_author) #=> An instance of `self`
      #   ctx.draft_title #=> 'DRAFT: Cool Article'
      #
      # @param seed_data [Hash<Symbol => Object>] a hash mapping a seed template's names on to instances of the types
      #   expressed in that template
      # @raise [SeedNotFoundError] if there no seed exists with the given names
      def materialize_with(**seed_data)
        seed = seeds.find(seed_data.keys)
        raise SeedNotFoundError, "Could not find a seed for keys #{seed_data.keys.inspect}" unless seed

        seed.materialize_from(seed_data)
      end

      def seeds
        @seeds ||= SeedCollection.new
      end

      private

      def new_seed(seed_template, &seed_config)
        Seed.new(seed_template, self, &seed_config)
      end
    end
  end
end
