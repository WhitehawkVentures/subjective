# frozen_string_literal: true

require 'subjective/attribute_specable'
require 'subjective/schemable'
require 'subjective/validatable'
require 'subjective/seedable'

module Subjective
  ##
  # Base class and DSL for a context container.
  #
  #   class UserContext < Subjective::Context
  #     define_schema do
  #       attribute :first_name, Types::String
  #       attribute :last_name, Types::String.optional
  #       attribute :email, Types::String
  #       attribute :age, Types::Coercible::Integer
  #     end
  #
  #     define_validations do
  #       validates :first_name, presence: true
  #       validates :age, numericality: { greater_than: 18 }
  #     end
  #
  #     seed_with(user: User) do
  #       first_name { user.first_name }
  #       last_name { user.last_name }
  #       email { user.email }
  #       age { user.age }
  #     end
  #   end
  #
  # A context can be populated with values directly, or with any of the defined seeds:
  #
  #   ctx1 = UserContext.new first_name: 'Bob', last_name: 'Ross', email: 'bob@ross.com', age: 22
  #   ctx2 = UserContext.materialize_with(user: User.find_by(email: 'bob@ross.com'))
  #
  class Context
    extend AttributeSpecable
    include Schemable
    include Validatable
    include Seedable

    def initialize(params = {})
      @_struct_core = _schema_template.create_core(params)
    end
  end
end
