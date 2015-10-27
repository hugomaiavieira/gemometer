shared_examples "notifier" do |name|
  describe '#notify' do
    describe 'when outdated' do
      it 'should send notification' do
        VCR.use_cassette("#{name}_success") do
          expect(subject.notify).to be(true)
        end
      end

      describe 'notification request error' do
        subject { described_class.new({gems: gems, url: failure_url}) }

        it 'should raise error' do
          VCR.use_cassette("#{name}_failure") do
            expect{subject.notify}.to raise_error(Gemometer::NotifyError, '404: Not Found')
          end
        end
      end
    end

    describe 'when up to date' do
      let(:gems) { [] }

      it 'should not send notification' do
        expect(subject.notify).to be(false)
      end
    end
  end
end
