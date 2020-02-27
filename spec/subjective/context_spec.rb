require 'spec_helper'

# These are integration specs for Subjective contexts, using various strategies
RSpec.describe Subjective::Context do
  after do
    Subjective::Seedable.seed_type_index.clear
  end

  context 'struct strategy: dry-struct; validation strategy: activemodel' do
    before do
      Subjective.use :dry_struct
      Subjective.validate_with :activemodel

      stub_const('Types', Module.new do
        include Dry::Types.module
      end)
    end

    it 'can set a String attribute' do
      stub_const('Thing', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
        end
      end)

      expect(Thing.new(name: 'Tyler').name).to eq('Tyler')
    end

    it 'can set a coercible Integer attribute' do
      stub_const('Thing', Class.new(Subjective::Context) do
        define_schema do
          attribute :age, Types::Coercible::Integer
        end
      end)

      expect(Thing.new(age: '30').age).to eq(30)
    end

    it 'can validate an attribute' do
      stub_const('Thing', Class.new(Subjective::Context) do
        class << self
          def name
            'Thing'
          end
        end

        define_schema do
          attribute :name, Types::String
          attribute :age, Types::Coercible::Integer
        end

        define_validations do
          validates :name, length: { minimum: 5 }
        end
      end)

      expect(Thing.new(name: 'Bob', age: 4)).to_not be_valid
    end

    it 'has validation error messages when instances are invalid' do
      stub_const('Thing', Class.new(Subjective::Context) do
        class << self
          def name
            'Thing'
          end
        end

        define_schema do
          attribute :name, Types::String
          attribute :age, Types::Coercible::Integer
        end

        define_validations do
          validates :name, length: { minimum: 5 }
        end
      end)

      expect(Thing.new(name: 'Bob', age: 5).validation_error_messages).to_not be_empty
    end

    it 'can be generated using a seed' do
      stub_const('Widget', Struct.new(:full_name, :count))

      stub_const('Thing', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
          attribute :age, Types::Coercible::Integer
        end

        seed_with(widget: Widget) do
          name { widget.full_name }
          age { widget.count }
        end
      end)

      widget = Widget.new('Bob Smith', 42)

      expect(Thing.materialize_with(widget: widget).name).to eq('Bob Smith')
    end

    it 'returns an associated seed when searching via an object' do
      stub_const('Widget', Struct.new(:full_name, :count))

      stub_const('Thing', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
          attribute :age, Types::Coercible::Integer
        end

        seed_with(widget: Widget) do
          name { widget.full_name }
          age { widget.count }
        end
      end)

      widget = Widget.new('Carl Grant', 27)

      expect(Subjective.available_seeds_for([widget]).first.context_klass).to eq(Thing)
    end

    it 'can be used as a dry-struct hash_schema and be initialized from an instance' do
      stub_const('Widget', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
        end
      end)

      stub_const('Gadget', Class.new(Subjective::Context) do
        define_schema do
          attribute :widget, Widget
        end
      end)

      widget = Widget.new(name: 'Eyyyyy')
      gadget = Gadget.new(widget: widget)

      expect(gadget.widget.name).to eq('Eyyyyy')
    end

    it 'can be used as a dry-struct hash_schema and be initialized from a hash' do
      stub_const('Widget', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
        end
      end)

      stub_const('Gadget', Class.new(Subjective::Context) do
        define_schema do
          attribute :widget, Widget
        end
      end)

      gadget = Gadget.new(widget: { name: 'Sup' })

      expect(gadget.widget.name).to eq('Sup')
    end

    it 'can be converted to a hash' do
      stub_const('Widget', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
        end
      end)

      expect(Widget.new(name: 'Some widget').to_h[:name]).to eq('Some widget')
    end

    it 'can be converted to a hash with nested attributes' do
      stub_const('Widget', Class.new(Subjective::Context) do
        define_schema do
          attribute :name, Types::String
        end
      end)

      stub_const('Gadget', Class.new(Subjective::Context) do
        define_schema do
          attribute :widget, Widget
        end
      end)

      gadget = Gadget.new(widget: { name: 'Hello' })

      expect(gadget.to_h[:widget][:name]).to eq('Hello')
    end
  end
end
