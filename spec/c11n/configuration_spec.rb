require 'spec_helper'

describe C11n::Configuration do
  let(:configuration) { C11n::Configuration.new }

  describe '#method_missing' do
    it { expect { configuration.some_key = 'value' }.not_to raise_error }

    context 'when a setter method is invoked before' do
      let(:value) { 'value' }
      before { configuration.some_key = value }

      it { expect(configuration.configurations[:some_key]).to eq(value) }
    end

    context 'when a getter method is invoked' do
      context 'when configurations has an exact match' do
        let(:value) { 'configuration value' }
        before { configuration.configurations[:some_key] = value }

        it { expect(configuration.some_key).to eq(value) }
      end

      context 'when configurations does not have an exact match' do
        it { expect { configuration.some_key }.to raise_error(NoMethodError) }
      end
    end
  end

  describe '#external' do
    context 'when it is invoked with a block' do
      it { expect(configuration.external(:google_drive) { |config| config.some = 'thing' }).to be_kind_of(C11n::Configuration) }
    end

    context 'when it is invoked without a block' do
      context 'when an external service is configured before' do
        before { configuration.external(:google_drive) { |config| config.some = 'thing' } }

        it { expect(configuration.externals[:google_drive]).not_to be_nil }
      end

      context 'when no external service with matching name is configured before' do
        it { expect { configuration.external(:google_drive) }.to raise_error(C11n::Configuration::NotConfigured) }
      end
    end
  end

  describe '#load_from_hash' do
    let(:google_config) { { other: 'things' } }
    let(:config_hash) { { some: 'thing', external: { google: google_config } } }

    it { expect { configuration.load_from_hash(config_hash) }.not_to raise_error }

    context 'when it is loaded' do
      before { configuration.load_from_hash(config_hash) }

      it { expect(configuration.some).to eq('thing') }
      it { expect(configuration.external(:google).to_hash).to eq(google_config) }
    end
  end
end
