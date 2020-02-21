require 'spec_helper'

RSpec.describe Subjective::Validatable do
  let(:base) do
    klass = Class.new do
      extend Subjective::AttributeSpecable
      include Subjective::Validatable

      attr_accessor :_struct_core
    end
  end
  let(:core) { double 'core', read_attribute: true }
  subject { base.new.tap { |obj| obj._struct_core = core } }

  before do
    Subjective.validate_with :testing
  end

  describe '.define_validations' do
    it 'passes the DSL along to the template' do
      target = double('target')
      expect(target).to receive(:ping) # This assumes the Testing strategy just calls the block

      base.define_validations { target.ping }
    end
  end

  describe 'attribute validation' do
    it 'responds to #valid?' do
      expect(subject).to be_valid
    end

    it 'can actually be invalid' do
      allow(core).to receive(:read_attribute).with(:validate_me).and_return(false)

      expect(subject).to_not be_valid
    end

    it 'responds to #validation_errors' do
      expect(subject.validation_errors).to be_a(Hash)
    end

    it 'resonds to #validation_error_messages' do
      expect(subject.validation_error_messages).to be_an(Array)
    end
  end
end
