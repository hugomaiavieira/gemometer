require 'spec_helper'

describe Gemometer::Parser do

  subject { described_class.new(Gemometer::System.bundle_outdated) }

  describe '#parse' do
    describe 'when is outdated' do
      it 'should add correctly instanciated gems on gems array' do
        mock_bundle_outdated_some
        subject.parse

        expect(subject.gems).to_not be_empty

        gem = subject.gems.first

        expect(gem).to be_kind_of(Gemometer::Gem)
        expect(gem.name).to eql('aws-sdk')
        expect(gem.newest).to eql('2.1.32')
        expect(gem.installed).to eql('1.66.0')
        expect(gem.requested).to eql('= 1.66.0')
        expect(gem.group).to eql('default')
      end
    end

    describe 'when is up to date' do
      it 'should not add items on gems attribute' do
        mock_bundle_outdated_none
        subject.parse

        expect(subject.gems).to be_empty
      end
    end
  end
end
