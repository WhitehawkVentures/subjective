RSpec.describe Subjective do
  it 'has a version number' do
    expect(Subjective::VERSION).not_to be nil
  end

  describe '#available_seeds_for' do
    after do
      Subjective::Seedable.seed_type_index.clear
    end

    it 'returns all relevant seeds on a single context class for a collection of two objects' do
      stub_const('Widget', Class.new(Subjective::Context) do
        seed_with(a: String, b: Integer) {}
        seed_with(c: String) {}
      end)

      expect(Subjective.available_seeds_for(['abc', 123]).length).to eq(2)
    end

    it 'returns only relevant seeds on a single context class for incomplete input' do
      stub_const('Widget', Class.new(Subjective::Context) do
        seed_with(a: String, b: Integer) {}
        seed_with(c: String) {}
      end)

      expect(Subjective.available_seeds_for(['abc']).length).to eq(1)
    end

    it 'returns all relevant seeds on multiple context classes for a collection of objects' do
      stub_const('Widget', Class.new(Subjective::Context) do
        seed_with(a: String, b: Integer) {}
        seed_with(c: String) {}
      end)

      stub_const('Gadget', Class.new(Subjective::Context) do
        seed_with(d: String) {}
        seed_with(e: Hash, f: Array) {}
        seed_with(g: Float) {}
      end)

      expect(Subjective.available_seeds_for(['abc', 123, {}, []]).length).to eq(4)
    end

    it 'returns only relevant seeds on multiple context classes for incomplete input' do
      stub_const('Widget', Class.new(Subjective::Context) do
        seed_with(a: String, b: Integer) {}
        seed_with(c: String) {}
      end)

      stub_const('Gadget', Class.new(Subjective::Context) do
        seed_with(d: String) {}
        seed_with(e: Hash, f: Array) {}
      end)

      expect(Subjective.available_seeds_for(['abc']).length).to eq(2)
    end
  end
end
