# frozen_string_literal: true

require 'spec_helper'
require 'subjective/struct_strategies/dry_struct'

RSpec.describe Subjective::StructStrategies::DryStruct do
  it_behaves_like Subjective::StructStrategy

  before(:context) do
    described_class.setup!
  end

  before(:example) do
    stub_const('Types', Module.new { include Dry.Types() })
  end

  describe '#define' do
    subject { described_class.new }

    it 'properly exposes attribute presence' do
      subject.define(proc { attribute :name, Types::String })

      expect(subject.attribute?(:name)).to be(true)
    end

    it 'properly exposes attribute absence' do
      subject.define(proc { attribute :name, Types::String })

      expect(subject.attribute?(:color)).to be(false)
    end

    it 'enables creation of a core using the defined attributes' do
      subject.define(proc { attribute :name, Types::String })

      expect(subject.create_core(name: 'Alan').read_attribute(:name)).to eq('Alan')
    end

    it 'properly exposes attribute types' do
      subject.define(proc { attribute :name, Types::String })

      expect(subject.type_for(:name)).to eq(String)
    end

    it 'properly exposes attribute defaults for attributes without defaults' do
      subject.define(proc { attribute :name, Types::String })

      expect(subject.default_for(:name)).to be_nil
    end

    it 'properly exposes attribute default for attributes with defaults' do
      subject.define(proc { attribute :name, Types::String.default('Bob') })

      expect(subject.default_for(:name)).to eq('Bob')
    end

    it 'properly exposes attribute optional status for required attributes' do
      subject.define(proc { attribute :name, Types::String })

      expect(subject.optional_for(:name)).to be(false)
    end

    it 'properly exposes attribute optional status for optional attributes' do
      subject.define(proc { attribute :name, Types::String.optional })

      expect(subject.optional_for(:name)).to be(true)
    end
  end
end
