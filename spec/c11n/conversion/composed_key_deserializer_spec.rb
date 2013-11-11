# -*- encoding: utf-8 -*-

require 'spec_helper'

describe C11n::Conversion::ComposedKeyDeserializer do
  describe '#deserialize' do
    let(:source) { [['general.title', '너말고 니친구'], ['views.confirmations.title', '너말고 니친구 메일 인증'], ['views.confirmations.send', '확인 메일 다시 받기'], ['views.passwords.title', '패스워드 리셋하기']] }
    let(:result) { { general: { title: '너말고 니친구' }, views: { confirmations: { title: '너말고 니친구 메일 인증', send: '확인 메일 다시 받기' }, passwords: { title: '패스워드 리셋하기' } } } }
    let(:deserializer) { C11n::Conversion::ComposedKeyDeserializer.new(source) }

    it { expect { deserializer.deserialize }.not_to raise_error }
    it { expect(deserializer.deserialize).to eq(result) }
  end

  describe '#path_for' do
    let(:path) { 'views.confirmations.title' }
    let(:deserializer) { C11n::Conversion::ComposedKeyDeserializer.new([]) }

    it { expect(deserializer.send(:path_for, path)).to eq([:views, :confirmations, :title]) }
  end

  describe '#create_or_get_leaf_node_for' do
    let(:path) { [:views, :confirmations, :title] }
    let(:deserializer) { C11n::Conversion::ComposedKeyDeserializer.new([]) }

    before { deserializer.create_or_get_leaf_node_for(path) }

    it { expect(deserializer.translations[:views]).not_to be_nil }
    it { expect(deserializer.translations[:views][:confirmations]).not_to be_nil }
  end
end
