require 'spec_helper'

describe Gemometer::Gem do
  describe "#message_line" do
    context "when full filled" do
      subject { described_class.new(name: 'aws-sdk', newest: '2.1.32', installed: '1.66.0', requested: '= 1.66.0', group: 'default') }

      it "should return the full message" do
        expect(subject.message_line).to eql('(newest 2.1.32, installed 1.66.0, requested: = 1.66.0) in group "default"')
      end
    end

    context "when does not have group" do
      subject { described_class.new(name: 'aws-sdk', newest: '2.1.32', installed: '1.66.0', requested: '= 1.66.0', group: nil) }

      it "should return the message without 'group'" do
        expect(subject.message_line).to eql('(newest 2.1.32, installed 1.66.0, requested: = 1.66.0)')
      end
    end

    context "when does not have requested" do
      subject { described_class.new(name: 'aws-sdk', newest: '2.1.32', installed: '1.66.0', requested: nil, group: 'default') }

      it "should return the message without 'requested'" do
        expect(subject.message_line).to eql('(newest 2.1.32, installed 1.66.0) in group "default"')
      end
    end
  end
end
