require 'spec_helper'

describe Gemometer::GemArray do
  let(:gem_default)     { instance_double(Gemometer::Gem, group: 'default') }
  let(:gem_development) { instance_double(Gemometer::Gem, group: 'development') }
  let(:gem_not_listed)  { instance_double(Gemometer::Gem, group: nil) }

  it { is_expected.to be_kind_of(Array) }

  describe '#listed' do
    subject { described_class.new([gem_default, gem_development, gem_not_listed]) }

    it 'should return the listed gems on any group' do
      listed = subject.listed
      expect(listed).to be_a(Gemometer::GemArray)
      expect(listed.size).to eql(2)
      expect(listed).to include(gem_default, gem_development)
    end
  end
end
