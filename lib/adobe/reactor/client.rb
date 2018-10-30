require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'adobe/reactor/utils'

module Adobe::Reactor
  class Client
    DEFAULTS = {
      :scheme => 'http',
      :host => 'localhost',
      :port => 9010,
      :version => '1',
      :logging_level => 'WARN',
      :connection_timeout => 60,
      :read_timeout => 60,
      :logger => nil,
      :ssl_verify => true,
      :faraday_adapter => ::Faraday.default_adapter,
      :accept_type => 'application/vnd.api+json'
    }.freeze

    HEADERS = {
      'Accept' => 'application/vnd.api+json;revision=1',
      'Content-Type' => 'application/vnd.api+json',
      'X-Api-Key' => 'Activation-DTM',
      'Authorization' => "Bearer #{ENV['MC_TOKEN_STAGE']}"
    }.freeze

    attr_reader :conn
    attr_accessor :api_key, :api_token, :config

    def initialize(api_key, api_token, options={})
      @api_key = api_key
      @api_token = api_token
      @config = DEFAULTS.merge options
      build_conn
    end

    def get(href)
      hydrate_resource(@conn.get(href))
    end

    def post(resource)
    end

    def patch(resource)
      payload = resource.serialized
      response = @conn.patch(resource.href, payload)
      hydrate_resource(response)
    end

    def delete(href)
      @conn.delete(href)
    end

    def hydrate_resources(data)
    end

    def hydrate_resource(response)
      data = response.body['data']
      type_of = data['type']
      attributes = data['attributes']
      id = data['id']
      links = data['links']

      klass = Object.const_get('Adobe::Reactor::' + Utils.classify(type_of))
      klass.new(attributes: attributes, id: id, links: links)
    end


    def build_conn
      if config[:logger]
        logger = config[:logger]
      else
        logger = Logger.new(STDOUT)
        logger.level = Logger.const_get(config[:logging_level].to_s)
      end

      # Faraday::Response.register_middleware :handle_balanced_errors => lambda { Faraday::Response::RaiseDtmError }

      options = {
        request: {
          open_timeout: config[:connection_timeout],
          timeout: config[:read_timeout]
        },
        ssl: {
          verify: @config[:ssl_verify] # Only set this to false for testing
        }
      }
      @conn = Faraday.new(url, options) do |cxn|
        cxn.request  :json

        cxn.response :logger, logger
        # cxn.response :handle_balanced_errors
        cxn.response :json
        # cxn.response :raise_error  # raise exceptions on 40x, 50x responses
        cxn.adapter  config[:faraday_adapter]
      end
      conn.path_prefix = '/'
      conn.headers['User-Agent'] = "adobe-reactor-ruby/#{Adobe::Reactor::VERSION}"
      conn.headers['Content-Type'] = "application/vnd.api+json"
      conn.headers['Accept'] = "#{@config[:accept_type]};revision=#{@config[:version]}"
      conn.headers.merge!(HEADERS)
    end


     def url
       builder = (config[:scheme] == 'http') ? URI::HTTP : URI::HTTPS
       builder.build({:host => config[:host],
                      :port => config[:port],
                      :scheme => config[:scheme]})
     end
  end
end
