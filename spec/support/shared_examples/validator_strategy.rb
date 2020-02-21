require 'subjective/validator_strategy'

RSpec.shared_examples Subjective::ValidatorStrategy do
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

  before(:context) do
    described_class.setup!
  end

  describe '#define' do
    it 'exists' do
      expect(subject).to respond_to(:define).with(1).argument
    end
  end

  describe '#valid?' do
    it 'exists' do
      expect(subject).to respond_to(:valid?).with(1).argument
    end
  end

  describe '#validation_errors' do
    it 'exists' do
      expect(subject).to respond_to(:validation_errors).with(1).argument
    end
  end

  describe '#validation_error_messages' do
    it 'exists' do
      expect(subject).to respond_to(:validation_error_messages).with(1).argument
    end
  end
end
