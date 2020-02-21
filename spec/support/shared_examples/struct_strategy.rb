require 'subjective/struct_strategy'

RSpec.shared_examples Subjective::StructStrategy do
  before(:context) do
    described_class.setup!
  end

  describe '#define' do
    it 'exists' do
      expect(described_class.new).to respond_to(:define).with(1).argument
    end
  end

  describe '#create_core' do
    it 'returns an object that responds to #attribute?' do
      expect(described_class.new.create_core).to respond_to(:attribute?).with(1).argument
    end

    it 'returns an object that responds to #read_attribute' do
      expect(described_class.new.create_core).to respond_to(:read_attribute).with(1).argument
    end
  end

  describe '#attribute?' do
    it 'exists' do
      expect(described_class.new).to respond_to(:attribute?).with(1).argument
    end
  end

  describe '#type_for' do
    it 'exists' do
      expect(described_class.new).to respond_to(:type_for).with(1).argument
    end
  end

  describe '#default_for' do
    it 'exists' do
      expect(described_class.new).to respond_to(:default_for).with(1).argument
    end
  end

  describe '#optional_for' do
    it 'exists' do
      expect(described_class.new).to respond_to(:optional_for).with(1).argument
    end
  end
end
