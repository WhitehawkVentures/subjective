# frozen_string_literal: true

require 'spec_helper'
require 'subjective/validator_strategies/activemodel'

RSpec.describe Subjective::ValidatorStrategies::ActiveModel do
  let(:context_klass) do
    klass = Class.new do
      class << self
        def name
          'ContextKlass'
        end
      end
    end
  end
  subject { described_class.new(context_klass) }

  it_behaves_like Subjective::ValidatorStrategy

  def build_core(attrs)
    result = double('core', attribute?: false, read_attribute: false)

    attrs.each do |k, v|
      allow(result).to receive(:attribute?).with(k).and_return(true)
      allow(result).to receive(:read_attribute).with(k).and_return(v)
    end

    result
  end

  before(:context) do
    described_class.setup!
  end

  describe '#define' do
    it 'properly validates an attribute' do
      subject.define(proc { validates :name, presence: true })

      expect(subject.valid?(build_core(name: 'Alan'))).to be(true)
    end

    it 'properly invalidates an attribute' do
      subject.define(proc { validates :name, presence: true })

      expect(subject.valid?(build_core(name: ''))).to be(false)
    end

    it 'properly exposes error hashes for valid cores' do
      subject.define(proc { validates :name, presence: true })

      expect(subject.validation_errors(build_core(name: 'Bob'))).to respond_to(:[])
    end

    it 'properly exposes error hashes for invalid cores' do
      subject.define(proc { validates :name, presence: true })

      expect(subject.validation_errors(build_core(name: ''))).to respond_to(:[])
    end

    it 'properly exposes error messages for valid cores' do
      subject.define(proc { validates :name, presence: true })

      expect(subject.validation_error_messages(build_core(name: 'Carl'))).to be_empty
    end

    it 'properly exposes error messages for invalid cores' do
      subject.define(proc { validates :name, presence: true })

      expect(subject.validation_error_messages(build_core(name: ''))).to be_present
    end
  end
end
