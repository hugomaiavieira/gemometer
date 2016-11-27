# https://documentation.mailgun.com/api-sending.html
module Gemometer
  module Notifiers
    class Mailgun < Base
      attr_reader :domain, :to

      def initialize(opts)
        @domain = opts[:domain]
        @to     = opts[:to]
        super(opts)
      end

      def self.mandatory_options
        [:domain, :to, :key]
      end

      def message
        msg = '<p>Outdated gems:</p><ul>'
        gems.each { |g| msg += "<li>#{ruby_gems_link(g.name)} #{g.message_line}</li>" }
        msg += '</ul>'
      end

      def username
        'api'
      end

      def url
        "https://api.mailgun.net/v3/#{domain}/messages"
      end

      private

      def data
        {
          from:    sender,
          to:      to,
          html:    message,
          subject: 'Some gems are Outdated'
        }
      end

      def sender
        "Gemometer <gemometer@#{domain}>"
      end

      def ruby_gems_link(name)
        "<a href='https://rubygems.org/gems/#{name}'>#{name}</a>"
      end

      def json?
        false
      end

      def require_auth?
        true
      end
    end
  end
end

