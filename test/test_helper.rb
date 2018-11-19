$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "adobe/reactor"

require "minitest/autorun"

api_token = ENV['REACTOR_API_TOKEN']
api_key = ENV['REACTOR_API_KEY']
Adobe::Reactor.configure(api_key, api_token)
