require 'spec_helper'

describe Gemometer::Parser do

  subject { described_class.new(Gemometer::System.bundle_outdated) }

  describe '#parse' do
    describe 'when is outdated' do
      it 'should return the outdated gems array' do
        mock_bundle_outdated_some

        expect(subject.parse).to eql([
          { name: 'byebug', newest: '6.0.2', installed: '5.0.0'},
          { name: 'rspec-rails', newest: '0.10.3', installed: '0.10.2'},
          { name: 'some_gem', newest: '4.2.0', installed: '3.6.0'}
        ])
      end
    end

    describe 'when is up to date' do
      it 'should return an empty array' do
        mock_bundle_outdated_none

        expect(subject.parse).to eql([])
      end
    end
  end
end
