require 'spec_helper'

describe Gemometer::Notifiers::Slack do

  let(:gems) do
    [
      { name: 'aws-sdk', newest: '2.1.32', installed: '1.66.0', requested: '= 1.66.0', group: 'default' },
      { name: 'byebug', newest: '6.0.2', installed: '5.0.0'},
      { name: 'rspec-rails', newest: '0.10.3', installed: '0.10.2'}
    ]
  end
  let(:success_url) { 'https://hooks.slack.com/services/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' }
  let(:failure_url) { 'https://hooks.slack.com/services/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' }

  subject { described_class.new({gems: gems, url: success_url, channel: '#gemometer'}) }

  describe '#message' do
    it 'should return the gems list as html' do
      str = "Outdated gems:\n
            <https://rubygems.org/gems/aws-sdk|aws-sdk> (newest 2.1.32, installed 1.66.0, requested: = 1.66.0) in group \"default\"
            <https://rubygems.org/gems/byebug|byebug> (newest 6.0.2, installed 5.0.0)
            <https://rubygems.org/gems/rspec-rails|rspec-rails> (newest 0.10.3, installed 0.10.2)\n-".gsub(/^ +/, '    ')
      expect(subject.message).to eql(str)
    end
  end

  it_behaves_like 'notifier', described_class.name.downcase
end
