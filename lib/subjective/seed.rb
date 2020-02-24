# frozen_string_literal: true

require 'subjective/materializer'

module Subjective
  # @private
  class Seed
    attr_reader :names, :materializer

    def initialize(names, context_klass, &config)
      @names = process_hash(names)
      @materializer = new_materializer(@names.keys, context_klass, config)
    end

    def materialize_from(data)
      data = process_hash(data)
      verify_new_materialization!(data)

      materializer.merge!(data)
    end

    def matches_keys?(other)
      keys.sort == other.keys.sort
    end

    def keys
      names.keys
    end

    private

    def process_hash(raw_names)
      raw_names.map { |k, v| [k.to_sym, v] }.to_h
    end

    def new_materializer(name_keys, context_klass, config)
      Materializer.new(name_keys, context_klass, config)
    end

    def verify_new_materialization!(data)
      raise_key_match_error unless matches_keys?(data)
    end

    def raise_key_match_error
      raise ArgumentError, "Seed data does not contain appropriate keys: #{keys.map(&:inspect).join(', ')}"
    end
  end
end
