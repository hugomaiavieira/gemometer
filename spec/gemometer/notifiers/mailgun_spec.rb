require 'spec_helper'

describe Gemometer::Notifiers::Mailgun do

  let(:gems) do
    [
      instance_double(Gemometer::Gem, name: 'aws-sdk',     message_line: '(newest 2.1.32, installed 1.66.0, requested: = 1.66.0) in group "default"'),
      instance_double(Gemometer::Gem, name: 'byebug',      message_line: '(newest 6.0.2, installed 5.0.0)'),
      instance_double(Gemometer::Gem, name: 'rspec-rails', message_line: '(newest 0.10.3, installed 0.10.2)')
    ]
  end

  subject { described_class.new(gems: gems, domain: 'hugomaiavieira.com', key: 'key-valid', to: 'johndoe@gmail.com') }

  describe '#message' do
    it 'should return the gems list as html' do
      str = "
        <p>Outdated gems:</p>
        <ul>
          <li><a href='https://rubygems.org/gems/aws-sdk'>aws-sdk</a> (newest 2.1.32, installed 1.66.0, requested: = 1.66.0) in group \"default\"</li>
          <li><a href='https://rubygems.org/gems/byebug'>byebug</a> (newest 6.0.2, installed 5.0.0)</li>
          <li><a href='https://rubygems.org/gems/rspec-rails'>rspec-rails</a> (newest 0.10.3, installed 0.10.2)</li>
        </ul>".gsub(/\n\s*/, '')
      expect(subject.message).to eql(str)
    end
  end

  describe '.mandatory_options' do
    it 'should return the mandatory options' do
      expect(described_class.mandatory_options).to eql([:domain, :to, :key])
    end
  end

  describe '#notify' do
    describe 'when outdated' do
      it 'should send notification' do
        VCR.use_cassette("mailgun_success") do
          expect(subject.notify).to eql(true)
        end
      end

      describe 'notification request error' do
        subject { described_class.new(gems: gems, domain: 'hugomaiavieira.com', key: 'key-wrong', to: 'johndoe@gmail.com') }

        it 'should raise error' do
          VCR.use_cassette("mailgun_failure") do
            expect{subject.notify}.to raise_error(Gemometer::NotifyError, '401: UNAUTHORIZED')
          end
        end
      end
    end

    describe 'when up to date' do
      let(:gems) { [] }

      it 'should not send notification' do
        expect(subject.notify).to eql(false)
      end
    end
  end
end
