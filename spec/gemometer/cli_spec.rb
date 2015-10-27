require 'spec_helper'
require 'gemometer/cli'

describe Gemometer::CLI do

  describe '.notify' do
    let(:options) { OpenStruct.new({notifier: :hipchat, url: 'http://foo.br'}) }
    let(:gems) { [{ name: 'byebug', newest: '6.0.2', installed: '5.0.0'}] }
    let(:notifier) { double('Gemometer::Notifiers::Hipchat') }

    before(:each) do
      described_class.instance_variable_set(:@options, options)

      allow(Gemometer::System).to receive(:bundle_outdated)
      allow(Gemometer::Parser).to receive_message_chain(:new, :parse) { gems }
      allow(Gemometer::Notifiers::Hipchat).to receive(:new).
        with(gems: gems, url: 'http://foo.br').
        and_return(notifier)
    end

    it 'successfully' do
      allow(notifier).to receive(:notify).and_return(true)
      described_class.notify
    end

    describe 'with errors' do
      before(:each) do
        allow(notifier).to receive(:notify).and_raise(Gemometer::NotifyError, '401: Unauthorized')
      end

      it 'should exit' do
        silence do
          expect{described_class.notify}.to raise_error(SystemExit)
        end
      end

      it 'should print on etderr' do
        silence do
          expect{begin described_class.notify; rescue SystemExit; end}.to output(/401: Unauthorized/).to_stderr
        end
      end
    end

  end

  describe '.parse_args' do
    subject { described_class.parse_args(args) }

    describe 'successfully' do
      let(:args) { %w[-n hipchat -u http://some-url] }

      it { is_expected.to be_an(OpenStruct) }

      it 'should return the options' do
        expect(subject.url).     to eql('http://some-url')
        expect(subject.notifier).to eql(:hipchat)
      end
    end

    describe 'with errors' do
      after(:each) do
        silence do
          expect{subject.notifier}.to raise_error(SystemExit)
          expect{begin subject.notifier; rescue SystemExit; end}.to output.to_stderr
        end
      end

      describe 'when invalid argument (OptionParser::InvalidArgument)' do
        let(:args) { %w[-n invalid -u http://some-url] }; it {}
      end

      describe 'when missing argument (OptionParser::MissingArgument)' do
        describe 'for url' do
          let(:args) { %w[-n hipchat -u ] }; it {}
        end

        describe 'for notifier' do
          let(:args) { %w[-n -u http://some-url] }; it {}
        end
      end

      describe 'when invalid option (OptionParser::InvalidOption)' do
        let(:args) { %w[--foo] }; it {}
      end
    end
  end
end
