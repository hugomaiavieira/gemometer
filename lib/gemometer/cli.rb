require 'optparse'
require 'ostruct'

require 'gemometer'

module Gemometer
  class CLI
    NOTIFIERS = Gemometer.notifiers
    MANDATORY = %w[notifier url]

    def self.start(args)
      @options = parse_args(args)
      notify
    end

    def self.parse_args(args)
      options = OpenStruct.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: gemometer [options]'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-n', '--notifier NOTIFIER', NOTIFIERS, {},
                'Specify the notifier app', "  (#{NOTIFIERS.join(', ')})") do |notifier|
          options.notifier = notifier
        end

        opts.on('-u', '--url URL',
                'Specify the app notification url') do |url|
          options.url = url
        end

        opts.on('-l', '--listed-only', "Only verify gems listed directly on Gemfile (don't vefify dependencies)") do
          options.listed_only = true
        end

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this message') do
          puts opts
          exit
        end

        opts.on_tail('--version', 'Show version') do
          puts Gemometer::VERSION
          exit
        end
      end

      begin
        opt_parser.parse!(args)
        missing = MANDATORY.select{ |param| options.send(param).nil? }
        if missing.any?
          abort("\nMissing options: #{missing.join(', ')}\n\n\n#{opt_parser}")
        end
      rescue OptionParser::InvalidArgument, OptionParser::MissingArgument, OptionParser::InvalidOption
        # Friendly output when parsing fails
         abort("\n#{$!}\n\n\n#{opt_parser}")
      end

      options
    end

    def self.notify
      begin
        parser = Gemometer::Parser.new(Gemometer::System.bundle_outdated)
        parser.parse
        gems = @options.listed_only ? parser.gems.listed : parser.gems

        Gemometer::Notifiers.const_get(@options.notifier.capitalize).new(
          gems: gems,
          url: @options.url
        ).notify
      rescue Gemometer::NotifyError => e
        abort(e.message)
      end
    end
  end
end
