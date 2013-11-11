# -*- encoding: utf-8 -*-
#
require 'spec_helper'

describe C11n::Conversion::Serializer do
  describe '#serialize' do
    let(:source) { { general: { title: '너말고 니친구' }, views: { confirmations: { title: '너말고 니친구 메일 인증', send: '확인 메일 다시 받기' }, passwords: { title: '패스워드 리셋하기' } } } }
    let(:result) { { 'general.title' => '너말고 니친구', 'views.confirmations.title' => '너말고 니친구 메일 인증', 'views.confirmations.send' => '확인 메일 다시 받기', 'views.passwords.title' => '패스워드 리셋하기' } }
    let(:serializer) { C11n::Conversion::Serializer.new(source) }

    it { expect(serializer.serialize).to eq(result) }
  end

  describe '#serialized_translations_for' do
    let(:prefix) { 'prefix' }
    let(:serializer) { C11n::Conversion::Serializer.new([]) }

    context 'when depth of recursion is 0' do
      let(:translations) { { hello: 'Hello', world: 'World' } }
      let(:result) { [C11n::Conversion::Serializer::Pair.new('prefix.hello', 'Hello'), C11n::Conversion::Serializer::Pair.new('prefix.world', 'World')] }

      it { expect(serializer.send(:serialized_translations_for, prefix, translations)).to eq(result) }
    end

    context 'when depth of recursion is larger than 0' do
      let(:translations) { { recursive: { hello: 'Hello', world: 'World' } } }
      let(:result) { [C11n::Conversion::Serializer::Pair.new('prefix.recursive.hello', 'Hello'), C11n::Conversion::Serializer::Pair.new('prefix.recursive.world', 'World')] }

      it { expect(serializer.send(:serialized_translations_for, prefix, translations)).to eq(result) }
    end
  end
end
