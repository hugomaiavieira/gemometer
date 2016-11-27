require 'net/http'
require 'uri'
require 'json'
require 'gemometer/errors'

module Gemometer
  module Notifiers
    class Base
      attr_reader :gems, :url, :key, :username

      def initialize(opts)
        @gems     = opts[:gems]
        @url      = opts[:url]
        @key      = opts[:key]
        @username = opts[:username]
      end

      def notify
        return false if gems.empty?
        response = make_request
        %w(204 200).include?(response.code) || raise(Gemometer::NotifyError.new("#{response.code}: #{response.message}"))
      end

      def self.mandatory_options
        raise NotImplementedError
      end

      private

      def make_request
        setup_auth
        setup_data
        http.request(request)
      end

      def setup_auth
        request.basic_auth(username, key) if require_auth?
      end

      def setup_data
        if json?
          request.content_type = 'application/json'
          request.body = JSON.generate(data)
        else
          request.set_form_data(data)
        end
      end

      def uri
        @uri ||= URI(url)
      end

      def http
        @http ||= begin
          _http = Net::HTTP.new(uri.host, uri.port)
          _http.use_ssl = (uri.scheme == "https")
          _http
        end
      end

      def request
        @request ||= Net::HTTP::Post.new(uri)
      end

      def data
        raise NotImplementedError
      end

      def json?
        true
      end

      def require_auth?
        false
      end
    end
  end
end
