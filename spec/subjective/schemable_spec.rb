require 'spec_helper'

RSpec.describe Subjective::Schemable do
  let(:base) do
    klass = Class.new do
      extend Subjective::AttributeSpecable
      include Subjective::Schemable

      def initialize(params = {})
        @_struct_core = _schema_template.create_core(params)
      end
    end
  end

  before do
    Subjective.use :testing
  end

  describe '.define_schema' do
    it 'passes the DSL along to the template' do
      target = double('target')
      expect(target).to receive(:ping) # This assumes the Testing strategy just calls the block

      base.define_schema { target.ping }
    end
  end

  describe '.attribute_spec' do
    it 'adds the "type" feature to the attribute spec' do
      expect(base.attribute_spec[:name].type).to eq(String) # Assumes String is hardcoded in the Testing strategy
    end

    it 'adds the "default" feature to the attribute spec' do
      expect(base.attribute_spec[:name].default).to eq('Testing!') # Assumes 'Testing!' is hardcoded in Testing
    end

    it 'adds the "optional?" feature to the attribute spec' do
      expect(base.attribute_spec[:name].optional?).to be(true)
    end
  end

  describe 'attribute assignment' do
    it 'returns the value assigned to a given attribute' do
      instance = base.new(name: 'Bob')

      expect(instance.name).to eq('Bob')
    end

    it 'throws if we try to access a nonexistant attribute' do
      instance = base.new(name: 'Carl')

      expect { instance.color }.to raise_error(NoMethodError)
    end
  end
end
