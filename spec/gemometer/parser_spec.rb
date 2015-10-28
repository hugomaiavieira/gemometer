require 'spec_helper'

describe Gemometer::Parser do

  subject { described_class.new(Gemometer::System.bundle_outdated) }

  describe '#parse' do
    describe 'when is outdated' do
      it 'should return the outdated gems array' do
        mock_bundle_outdated_some

        expect(subject.parse).to eql([
          { name: 'aws-sdk',    newest: '2.1.32', installed: '1.66.0', requested: '= 1.66.0', group: 'default' },
          { name: 'byebug',     newest: '6.0.2',  installed: '5.0.0',  requested: '~> 5.0.0', group: 'development' },
          { name: 'rollbar',    newest: '2.5.1',  installed: '2.4.0',  requested: '= 2.4.0',  group: 'default' },
          { name: 'shoulda',    newest: '3.0.1',  installed: '2.8.0',  requested: '~> 2.8',   group: 'test' },
          { name: 'sidekiq',    newest: '3.5.1',  installed: '3.5.0',  requested: '= 3.5.0',  group: 'default' },
          { name: 'hashie',     newest: '3.4.3',  installed: '3.4.2',  requested: nil,        group: nil },
          { name: 'minitest',   newest: '5.8.2',  installed: '5.8.1',  requested: nil,        group: nil },
          { name: 'multi_json', newest: '1.11.2', installed: '1.9.3',  requested: nil,        group: nil }
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
