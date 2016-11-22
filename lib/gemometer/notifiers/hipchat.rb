# https://www.hipchat.com/docs/apiv2/method/send_room_notification
module Gemometer
  module Notifiers
    class Hipchat < Base
      def message
        msg = '<p>Outdated gems:</p><ul>'
        gems.each { |g| msg += "<li>#{ruby_gems_link(g.name)} #{g.message_line}</li>" }
        msg += '</ul>'
      end

      private

      def data
        { message: message }
      end

      def ruby_gems_link(name)
        "<a href='https://rubygems.org/gems/#{name}'>#{name}</a>"
      end
    end
  end
end
