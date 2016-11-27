require 'optparse'
require 'ostruct'

require 'gemometer'

module Gemometer
  class CLI
    attr_reader :options, :notifier_name

    def initialize(args)
      @notifier_name = args.shift
      @options = OpenStruct.new
      parse_args(args)
    end

    def self.start(args)
      new(args).notify
    end

    def notify
      begin
        options.gems = gems
        notifier_class.new(options.to_h).notify
      rescue Gemometer::NotifyError => e
        abort(e.message)
      end
    end

    private

    def parse_args(args)
      begin
        opt_parser.parse!(args)
        verify_mandatory_options!
      rescue OptionParser::InvalidArgument, OptionParser::MissingArgument, OptionParser::InvalidOption
        # Friendly output when parsing fails
        abort("\n#{$!}\n\n\n#{opt_parser}")
      end
    end

    def verify_mandatory_options!
      missing = notifier_class.mandatory_options - options.to_h.keys
      if missing.any?
        abort("\nMissing options for '#{notifier_name}' notifier: #{missing.join(', ')}\n\n\n#{opt_parser}")
      end
    end

    def gems
      parser = Gemometer::Parser.new(Gemometer::System.bundle_outdated)
      parser.parse
      options.listed_only ? parser.gems.listed : parser.gems
    end

    def notifier_class
      @notifier_class ||= if Gemometer.notifiers.include?(notifier_name)
        Gemometer::Notifiers.const_get(notifier_name.capitalize)
      else
        abort("\nWrong notifier '#{notifier_name}'. Available notifiers: #{Gemometer.notifiers.join(', ')}\n\n\n#{opt_parser}")
      end
    end

    def opt_parser
      @opt_parser ||= OptionParser.new do |opts|
        opts.banner = 'Usage: gemometer NOTIFIER [options]'

        opts.separator ''
        opts.separator "Available notifiers: #{Gemometer.notifiers.join(', ')}"
        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-u', '--url URL',
                'Specify the app notification url',
                  '  Mandatory for Slack and Hipchat.') do |url|
          options.url = url
        end

        opts.on('-k', '--key API Key',
                'Specify the API Key',
                  '  Mandatory for mailgun.') do |key|
          options.key = key
        end

        opts.on('-t', '--to EMAIL',
                'Specify the email address of the recipient(s). You can use commas to separate multiple recipients.',
                  '  Mandatory for mailgun.') do |to|
          options.to = to
        end

        opts.on('-d', '--domain DOMAIN',
                'Specify the domain configured on mailgun.',
                  '  Mandatory for mailgun.') do |domain|
          options.domain = domain
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on('-l', '--listed-only', "Only verify gems listed directly on Gemfile (don't verify dependencies)") do
          options.listed_only = true
        end

        opts.separator ''

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('--version', 'Show version') do
          puts Gemometer::VERSION
          exit
        end
      end
    end
  end
end
