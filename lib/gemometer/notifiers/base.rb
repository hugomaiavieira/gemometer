require 'net/http'
require 'uri'
require 'json'
require 'gemometer/errors'

module Gemometer
  module Notifiers
    class Base
      attr_reader :gems, :url

      def initialize(opts)
        @gems = opts[:gems]
        @url  = opts[:url]
      end

      def notify
        return false if gems.empty?

        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")

        req = Net::HTTP::Post.new(uri)
        req.content_type = 'application/json'

        res = http.request(req, JSON.generate(data))

        %w(204 200).include?(res.code) ||
          raise(Gemometer::NotifyError.new("#{res.code}: #{res.message}"))
      end

      private

        def data
          raise NotImplementedError
        end
    end
  end
end