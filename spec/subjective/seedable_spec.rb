# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Subjective::Seedable do
  let(:base) do
    klass = Class.new do
      include Subjective::Seedable

      class << self
        def attribute?(attribute_name)
          attributes.include?(attribute_name.to_sym)
        end

        def attributes
          [:name, :total_price]
        end
      end

      attr_reader *attributes

      def initialize(params)
        self.class.attributes.each { |attribute| instance_variable_set("@#{attribute}", params[attribute]) }
      end
    end
  end

  let(:order_klass) { Struct.new(:product_name, :quantity, :unit_price) }

  describe '.seed_with' do
    it 'adds a seed to the collection' do
      expect(base.seeds).to be_empty # sanity check

      base.seed_with(order: order_klass) do
        name { order.product_name }
        total_price { order.quantity * order.unit_price }
      end

      expect(base.seeds).to_not be_empty
    end

    it 'throws if we already have a seed with the given names' do
      base.seed_with(order: order_klass) do
        name { order.product_name }
        total_price { order.quantity * order.unit_price }
      end

      expect { base.seed_with(order: Integer) {} }.to raise_error(ArgumentError)
    end
  end

  describe '.materialize_with' do
    it 'returns a context with the correct values' do
      base.seed_with(order: order_klass) do
        name { order.product_name }
        total_price { order.quantity * order.unit_price }
      end

      expect(base.materialize_with(order: order_klass.new('Foo', 3, 4.00))).to be_a(base)
    end

    it 'returns a context with the correct values (part 1)' do
      base.seed_with(order: order_klass) do
        name { order.product_name }
        total_price { order.quantity * order.unit_price }
      end

      expect(base.materialize_with(order: order_klass.new('Foo', 3, 4.00)).name).to eq('Foo')
    end

    it 'returns a context with the correct values (part 2' do
      base.seed_with(order: order_klass) do
        name { order.product_name }
        total_price { order.quantity * order.unit_price }
      end

      expect(base.materialize_with(order: order_klass.new('Foo', 3, 4.00)).total_price).to eq(12.00)
    end

    it 'throws if it cannot find the associated seed' do
      expect { base.materialize_with(user: 123) }.to raise_error(Subjective::SeedNotFoundError)
    end
  end
end
