# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Subjective::AttributeSpec do
  before(:example) do
    @prior_features = described_class.features
    described_class.instance_variable_set('@features', {})
  end

  after(:example) do
    described_class.instance_variable_set('@features', @prior_features)
  end

  describe '.add_feature!' do
    it 'sets the getter to the .features hash' do
      described_class.add_feature!(:something, ->(attribute) { attribute })

      expect(described_class.features[:something]).to be_a(Proc)
    end
  end

  describe '#[]' do
    let(:base) do
      klass = Class.new do
        class << self
          def attribute?(attribute_name)
            true
          end

          def message(addition)
            "Hello, #{addition}"
          end
        end
      end
    end
    subject { described_class.new(base) }

    before(:example) do
      described_class.add_feature!(:stuff, ->(attribute) { message(attribute) })
    end

    it 'is nil if the attribute does not exist on the base' do
      allow(base).to receive(:attribute?).with(:name).and_return(false)

      expect(subject[:name]).to be_nil
    end

    it "returns something whose name is the attribute's name" do
      expect(subject[:color].name).to eq(:color)
    end

    it 'returns something that responds to a feature name' do
      expect(subject[:color]).to respond_to(:stuff)
    end

    it 'returns something that will not respond to nonsense' do
      expect(subject[:color]).to_not respond_to(:anything_else)
    end

    it 'returns something that evaluates to the base class' do
      expect(subject[:color].stuff).to eq('Hello, color')
    end
  end
end
