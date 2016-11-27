require 'spec_helper'

describe Gemometer do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  describe '.notifiers' do
    it 'should return the list of available notifiers' do
      expect(described_class.notifiers).to eql(%w[hipchat slack mailgun])
    end
  end
end
