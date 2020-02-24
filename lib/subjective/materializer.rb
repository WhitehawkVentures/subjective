# frozen_string_literal: true

module Subjective
  # @private
  class Materializer
    DEFAULT_GENERATOR = proc { nil }

    attr_reader :_data_struct_klass, :_context_klass

    def initialize(names, context_klass, config)
      @_data_struct_klass = Struct.new(*names)
      @_context_klass = context_klass

      instance_eval(&config)
    end

    def merge!(**data)
      _context_klass.new(_map_data(data))
    end

    def method_missing(method_name, *args, &blk)
      valid_attribute?(method_name) ? _seed_attribute(method_name, blk) : super
    end

    def respond_to_missing?(method_name, *args)
      valid_attribute?(method_name) || super
    end

    private

    def _map_data(data)
      _seeded_attributes.map { |name, generator| [name, _new_data_struct(data).instance_eval(&generator)] }.to_h
    end

    def valid_attribute?(attribute)
      _context_klass.attribute?(attribute)
    end

    def _seed_attribute(attribute, generator)
      _seeded_attributes[attribute.to_sym] = generator
    end

    def _seeded_attributes
      @_seeded_attributes ||= {}
    end

    def _new_data_struct(data)
      _data_struct_klass.new(*data.values_at(*_data_struct_klass.members))
    end
  end
end
