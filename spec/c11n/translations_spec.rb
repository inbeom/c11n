require 'spec_helper'

describe C11n::Translations do
  let(:translations) { C11n::Translations.new }
  let(:translations_hash) { translations.to_hash }

  describe '#translations_for' do
    it { expect(translations.translations_for(:en)).not_to be_nil }
    it { expect(translations.translations_for(:en)).to be_empty }
    it { expect(translations.translations_for(:en)).to eq({}) }
  end

  describe '#add_translation' do
    let(:key) { 'attribute_a' }
    let(:value) { 'a' }
    before { translations.add_translation(:en, key, value) }

    it { expect(translations_hash[:en][key]).to eq(value) }
  end

  describe '#add_translations' do
    let(:raw_translations) { { 'attribute_a' => 'a', 'attribute_b' => 'b' } }

    before { translations.add_translations(:en, raw_translations) }

    it { expect(translations_hash[:en]).to eq(raw_translations) }
  end

  describe '#import_with' do
    let(:raw_translations) { { 'attribute_a' => 'a', 'attribute_b' => 'b' } }
    let(:mock_importer) { double(import: { en: raw_translations }, categories: {}, types: {}) }

    it { expect { translations.import_with(mock_importer) }.not_to raise_error }

    context 'when it is done before' do
      before { translations.import_with(mock_importer) }

      it { expect(translations_hash[:en]).to eq(raw_translations) }
    end
  end
end
