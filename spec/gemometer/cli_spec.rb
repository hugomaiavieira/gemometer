require 'spec_helper'
require 'gemometer/cli'

describe Gemometer::CLI do

  describe '.notify' do
    let(:gems)     { instance_double(Gemometer::GemArray, listed: instance_double(Gemometer::GemArray)) }
    let(:parser)   { instance_double(Gemometer::Parser, parse: true, gems: gems) }

    before(:each) do
      described_class.instance_variable_set(:@options, options)

      allow(Gemometer::System).to receive(:bundle_outdated)
      allow(Gemometer::Parser).to receive(:new).and_return(parser)
    end

    describe 'successfully' do
      before(:each) do
        allow_any_instance_of(Gemometer::Notifiers::Hipchat).to receive(:notify).and_return(true)
      end

      after(:each) { described_class.notify }

      context 'listed_only false' do
        let(:options)  { OpenStruct.new({notifier: :hipchat, url: 'http://foo.br', listed_only: false}) }

        it 'must notify with all gems' do
          expect(Gemometer::Notifiers::Hipchat).to receive(:new).
            with(gems: gems, url: 'http://foo.br').and_call_original
        end
      end

      context 'listed_only true' do
        let(:options)  { OpenStruct.new({notifier: :hipchat, url: 'http://foo.br', listed_only: true}) }

        it 'must notify with only the gems listed on Gemfile' do
          expect(Gemometer::Notifiers::Hipchat).to receive(:new).
            with(gems: gems.listed, url: 'http://foo.br').and_call_original
        end
      end
    end

    describe 'with errors' do
      let(:options)  { OpenStruct.new({notifier: :hipchat, url: 'http://foo.br'}) }
      let(:notifier) { instance_double(Gemometer::Notifiers::Hipchat) }

      before(:each) do
        allow(Gemometer::Notifiers::Hipchat).to receive(:new).and_return(notifier)
        allow(notifier).to receive(:notify).and_raise(Gemometer::NotifyError, '401: Unauthorized')
      end

      it 'should exit' do
        silence { expect{described_class.notify}.to raise_error(SystemExit) }
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
      let(:args) { %w[-n hipchat -u http://some-url -l] }

      it { is_expected.to be_an(OpenStruct) }

      it 'should return the options' do
        expect(subject.url).     to eql('http://some-url')
        expect(subject.notifier).to eql(:hipchat)
        expect(subject.listed_only).to eql(true)
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
