require 'spec_helper'
require 'gemometer/cli'

describe Gemometer::CLI do

  describe '.new' do
    subject { described_class.new(args) }

    context 'when wrong notifier' do
      let(:args) { %w[foo] }

      it 'should exit and print on stderr' do
        silence do
          expect{
            expect{subject}.to raise_error(SystemExit)
          }.to output(/Wrong notifier 'foo'. Available notifiers:/).to_stderr
        end
      end
    end

    context 'successfully' do
      let(:args) { %w[hipchat -u http://some-url -l] }

      it 'should define the notifier_name' do
        expect(subject.notifier_name).to eql('hipchat')
      end

      it 'should parse the args defining the options' do
        expect(subject.options).to eql(OpenStruct.new(url: "http://some-url", listed_only: true))
      end
    end
  end

  describe '#notify' do
    let(:gems)     { instance_double(Gemometer::GemArray, listed: instance_double(Gemometer::GemArray)) }
    let(:parser)   { instance_double(Gemometer::Parser, parse: true, gems: gems) }

    subject { described_class.new(args) }

    before(:each) do
      allow(Gemometer::System).to receive(:bundle_outdated)
      allow(Gemometer::Parser).to receive(:new).and_return(parser)
    end

    describe 'successfully' do
      before(:each) do
        allow_any_instance_of(Gemometer::Notifiers::Hipchat).to receive(:notify).and_return(true)
      end

      after(:each) { subject.notify }

      context 'listed_only false' do
        let(:args) { %w[hipchat -u http://foo.br] }

        it 'must notify with all gems' do
          expect(Gemometer::Notifiers::Hipchat).to receive(:new).
            with(hash_including(gems: gems)).and_call_original
        end
      end

      context 'listed_only true' do
        let(:args) { %w[hipchat -u http://foo.br -l] }

        it 'must notify with only the gems listed on Gemfile' do
          expect(Gemometer::Notifiers::Hipchat).to receive(:new).
            with(hash_including(gems: gems.listed)).and_call_original
        end
      end
    end

    describe 'with errors' do
      context 'when missing mandatory options' do
        let(:args) { %w[mailgun --domain my-domain.com] }

        it 'should exit and print on stderr' do
          silence do
            expect{
              expect{ subject.notify }.to raise_error(SystemExit)
            }.to output(/Missing options for 'mailgun' notifier: to, key/).to_stderr
          end
        end
      end

      context 'when args parser errors' do
        after(:each) do
          silence do
            expect{
              expect{ subject.notify }.to raise_error(SystemExit)
            }.to output(/Usage:/).to_stderr
          end
        end

        describe 'when invalid argument (OptionParser::InvalidArgument)' do
          let(:args) { %w[invalid] }; it {}
        end

        describe 'when missing argument (OptionParser::MissingArgument)' do
          let(:args) { %w[hipchat --url] }; it {}
        end

        describe 'when invalid option (OptionParser::InvalidOption)' do
          let(:args) { %w[hipchat --foo] }; it {}
        end
      end

      context 'when notifier notifying error' do
        let(:args) { %w[hipchat -u http://foo.brl] }
        let(:notifier) { instance_double(Gemometer::Notifiers::Hipchat) }

        before(:each) do
          allow(Gemometer::Notifiers::Hipchat).to receive(:new).and_return(notifier)
          allow(notifier).to receive(:notify).and_raise(Gemometer::NotifyError, '401: Unauthorized')
        end

        it 'should exit and print on stderr' do
          silence do
            expect{
              expect{ subject.notify }.to raise_error(SystemExit)
            }.to output(/401: Unauthorized/).to_stderr
          end
        end
      end
    end
  end

  describe '.start' do
    let(:args) { instance_double(Array) }
    let(:instance) { instance_double(described_class) }

    it 'should create an instance and call #notify on it' do
      expect(described_class).to receive(:new).with(args).and_return(instance)
      expect(instance).to receive(:notify)
      described_class.start(args)
    end
  end
end
