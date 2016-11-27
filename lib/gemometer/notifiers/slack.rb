# https://api.slack.com/incoming-webhooks
module Gemometer
  module Notifiers
    class Slack < Base
      attr_accessor :channel

      def initialize(opts)
        @channel = opts.delete(:channel)
        super(opts)
      end

      def self.mandatory_options
        [:url]
      end

      def message
        msg = "Outdated gems:\n"
        gems.each { |g| msg += "\n    #{ruby_gems_link(g.name)} #{g.message_line}" }
        msg += "\n-"
      end

      private

      def data
        {
          text:     message,
          channel:  channel,
          username: 'Gemometer'
          # icon_url: "https://TODO:add-icon.png"
        }.reject{ |_, v| v.nil? }
      end

      def ruby_gems_link(name)
        "<https://rubygems.org/gems/#{name}|#{name}>"
      end
    end
  end
end
