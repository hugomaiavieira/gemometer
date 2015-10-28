# https://api.slack.com/incoming-webhooks
module Gemometer
  module Notifiers
    class Slack < Base
      attr_accessor :channel

      def initialize(opts)
        @channel = opts.delete(:channel)
        super(opts)
      end

      def message
        html = "Outdated gems:\n"
        gems.each do |g|
          html += "\n    <https://rubygems.org/gems/#{g[:name]}|#{g[:name]}> (newest #{g[:newest]}, installed #{g[:installed]}"
          html += g[:requested] ? ", requested: #{g[:requested]})" : ")"
          html +=  " in group \"#{g[:group]}\"" if g[:group]
        end
        html += "\n-"
      end

      private

        def data
          {
            text:     message,
            channel:  channel,
            username: 'Gemometer'
            # icon_url: "https://TODO:add-icon.png"
          }.reject{ |k,v| v.nil? }
        end
      end
  end
end