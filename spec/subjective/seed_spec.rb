# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Subjective::Seed do
  let(:context_klass) do
    klass = Class.new do
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

  let(:user_klass) { Struct.new(:first_name, :last_name) }
  let(:order_klass) { Struct.new(:product_name, :quantity, :unit_price) }

  let(:names) { { user: user_klass, order: order_klass } }
  let(:config) do
    proc do
      name { "#{user.first_name} #{user.last_name}" }
      total_price { order.quantity * order.unit_price }
    end
  end

  subject { described_class.new(names, context_klass, &config) }

  describe '#materialize_from' do
    it 'returns an object with correct attributes' do
      expect(
        subject.materialize_from(
          user: user_klass.new('Bob', 'Smith'),
          order: order_klass.new('Thing', 2, 2.50)
        ).name
      ).to eq('Bob Smith')
    end

    it 'can take a hash with string keys' do
      expect(
        subject.materialize_from(
          user: user_klass.new('Bob', 'Smith'),
          'order' => order_klass.new('Thing', 2, 2.50)
        ).total_price
      ).to eq(5.00)
    end

    it 'throws if we get invalid seed data' do
      expect { subject.materialize_from(nonsense: 'asdf') }.to raise_error(ArgumentError)
    end
  end

  describe '#matches_keys?' do
    it 'is true if all keys match' do
      expect(subject.matches_keys?(user: 'abc', order: 'def')).to be(true)
    end

    it 'is false if there are missing keys' do
      expect(subject.matches_keys?(user: 'abc')).to be(false)
    end

    it 'is false if there are excess keys' do
      expect(subject.matches_keys?(user: 'abc', order: 'def', ticket: 'ghi')).to be(false)
    end
  end

  describe '#keys' do
    it 'returns a list of keys from the input names' do
      expect(subject.keys).to contain_exactly(:user, :order)
    end
  end
end
