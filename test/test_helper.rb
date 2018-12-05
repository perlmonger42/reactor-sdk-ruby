$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "adobe/reactor"

require "minitest/autorun"

api_token = ENV['REACTOR_API_TOKEN']
api_key = ENV['REACTOR_API_KEY']
#opts = {logging_level: 'DEBUG' }
opts = {}
Adobe::Reactor.configure(api_key, api_token, opts)

def test_co
  company_id = ENV['REACTOR_TEST_COMPANY_ID'] || 'CO958848cd700e44fa93dd5ab0f1a11dd3'
  Adobe::Reactor::Company.get(company_id)
end
