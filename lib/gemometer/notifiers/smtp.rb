require 'net/smtp'

module Gemometer
  module Notifiers
    class Smtp
      attr_reader :gems, :to, :sender, :server, :port, :domain, :username, :password, :scheme

      def initialize(opts)
        @gems     = opts[:gems]
        @to       = opts[:to]
        @sender   = ENV['SMTP_SENDER']
        @server   = ENV['SMTP_SERVER']
        @port     = ENV['SMTP_PORT'] || SMTP.default_port
        @domain   = ENV['SMTP_DOMAIN']
        @username = ENV['SMTP_USERNAME']
        @password = ENV['SMTP_PASSWORD']
        @scheme   = ENV['SMTP_AUTH_SCHEME'] || :plain # :plain, :login, or :cram_md5
      end

      def notify

        Net::SMTP.start(server, port, domain, username, password, scheme) do |smtp|
          smtp.send_message(message, sender, to)
        end
      end

      def message
        header + body
      end

      def header
%{
From: Gemometer <#{sender}>
To: #{to.join(",")}
MIME-Version: 1.0
Content-Type: text/html; charset=utf-8
Subject: Some gems are Outdated
}
      end

      def to
        @to.gsub("\s", '').split(",") if @to
      end

      def body
        msg = '<p>Outdated gems:</p><ul>'
        gems.each { |g| msg += "<li>#{ruby_gems_link(g.name)} #{g.message_line}</li>" }
        msg += '</ul>'
      end

      private

      def ruby_gems_link(name)
        "<a href='https://rubygems.org/gems/#{name}'>#{name}</a>"
      end
    end
  end
end
