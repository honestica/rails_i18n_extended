require 'spec_helper'

RSpec.describe I18n do
  let(:key)     { 'test.scope.foo' }
  let(:scope)   { nil }
  let(:locale)  { :en }
  let(:should_raise)   { false }

  subject(:translate) { I18n.t(key, scope: scope, locale: locale, raise: should_raise) }

  it { is_expected.to eq 'Bar' }

  context 'with a default' do
    let(:key) { 'test.scope.missing_with_default' }

    it { is_expected.to eq 'the default value' }
  end

  context 'with a scope' do
    let(:scope)   { [:test, :scope] }
    let(:key)   { :foo }

    it { is_expected.to eq 'Bar' }
  end

  context 'with a different locale' do
    let(:locale)  { :fr }

    it { is_expected.to eq 'Bar en francais' }

    context 'with a scope' do
      let(:scope)   { [:test, :scope] }
      let(:key)   { [:foo] }

      it { is_expected.to eq ['Bar en francais'] }
    end

    context 'with a default' do
      let(:key) { 'test.scope.missing_with_default' }

      it { is_expected.to eq 'la default value' }
    end
  end

  context 'with a missing translation' do
    let(:locale){ :de }

    it { is_expected.to eq 'Bar' }

    context 'when asked to raise' do
      let(:should_raise) { true }

      it { is_expected.to eq 'Bar' }
    end

    context 'with a default in the fallback locale' do
      let(:key) { 'test.scope.missing_with_default_only_en' }

      it { is_expected.to eq 'the default value only EN' }
    end

    context 'missing in the default locale too' do
      let(:key) { :baz }

      it 'should raise an error' do
        is_expected.to eq 'translation missing: de.baz'
      end

      context 'when asked to raise' do
        let(:should_raise) { true }

        it 'should raise an error' do
          expect{ translate }.to raise_error I18n::MissingTranslationData
        end
      end
    end
  end

  describe 'shortcuts' do
    let(:model) { Model.new test_enum_attribute: :enum_key }

    it 'works as expected' do
      expect(Model.t).to eq 'model'
      expect(Model.tp).to eq 'models'
      expect(Model.t_action(:test_action)).to eq 'Test action'
      expect(Model.t_attr(:test_attribute)).to eq 'Test attribute'
      expect(Model.t_panel(:test_panel)).to eq 'Test panel'

      expect(model.t_attr(:test_attribute)).to eq 'Test attribute'
      expect(model.t_attr(:test_enum_attribute)).to eq 'Test enum attribute'
      expect(model.t_enum(:test_enum_attribute)).to eq 'enum value'
      expect(Model.t_enum(:test_enum_attribute, :enum_key)).to eq 'enum value'
      expect(Model.new.t_enum(:test_enum_attribute)).to be_nil

      expect(true.t).to eq 'Yes'
      expect(false.t).to eq 'No'

      expect('test.scope.foo'.t).to eq 'Bar'
    end
  end
end