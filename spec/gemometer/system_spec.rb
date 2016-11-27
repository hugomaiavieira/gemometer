require 'spec_helper'

describe Gemometer::System do
  describe '.bundle_outdated' do
    it 'should call system "bundle" command with "outdated" argument' do
      expect(described_class).to receive(:`).with('bundle outdated')
      described_class.bundle_outdated
    end
  end
end
