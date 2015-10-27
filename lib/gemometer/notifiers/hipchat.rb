# https://www.hipchat.com/docs/apiv2/method/send_room_notification
module Gemometer
  module Notifiers
    class Hipchat < Base
      def message
        html = '<p>Outdated gems:</p><ul>'
        gems.each do |g|
          html += "<li><a href='https://rubygems.org/gems/#{g[:name]}'>#{g[:name]}</a> (newest #{g[:newest]}, installed #{g[:installed]})</li>"
        end
        html += '</ul>'
      end

      private

        def data
          { message: message }
        end
    end
  end
end