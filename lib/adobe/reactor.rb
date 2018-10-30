require 'adobe/reactor/version'
require 'adobe/reactor/client'
require 'adobe/reactor/resources'

module Adobe
  module Reactor
    @client = nil
    @config = {
      scheme: 'http',
      host: 'localhost',
      port: 9010,
      version: '1',
    }

    class << self
      attr_accessor :client
      attr_accessor :config

      def configure(api_key = nil, api_token = nil, options={})
        @config = @config.merge(options)
        @client = Client.new(api_key, api_token, @config)
      end
    end
  end
end
