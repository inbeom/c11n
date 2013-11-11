require 'spec_helper'

describe C11n::Table do
  let(:raw_table) do
    [
      ['Key', 'ko', 'en'],
      ['attribute_a', 'korean_a', 'english_a'],
      ['attribute_b', 'korean_b', 'english_b']
    ]
  end

  let(:table) { C11n::Table.new(raw_table) }

  describe '#table_for' do
    it { expect(table.table_for(:ko)).to eq([['attribute_a', 'korean_a'], ['attribute_b', 'korean_b']]) }
    it { expect(table.table_for(:en)).to eq([['attribute_a', 'english_a'], ['attribute_b', 'english_b']]) }
  end
end
