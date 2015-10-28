require 'spec_helper'

describe Gemometer::Notifiers::Hipchat do

  let(:gems) do
    [
      { name: 'aws-sdk', newest: '2.1.32', installed: '1.66.0', requested: '= 1.66.0', group: 'default' },
      { name: 'byebug', newest: '6.0.2', installed: '5.0.0'},
      { name: 'rspec-rails', newest: '0.10.3', installed: '0.10.2'}
    ]
  end
  let(:success_url) { 'https://api.hipchat.com/v2/room/806888/notification?auth_token=bLalUcXYzVnAgmZ2ca67fyp5BHRLg0wWLqjpvAmB' }
  let(:failure_url) { 'https://api.hipchat.com/v2/room/806889/notification?auth_token=gAmZb5a7Yqf0lZHVLacWmcgnLj2LARpBv6zUXpwy' }

  subject { described_class.new({gems: gems, url: success_url}) }

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

  it_behaves_like 'notifier', described_class.name.downcase
end
