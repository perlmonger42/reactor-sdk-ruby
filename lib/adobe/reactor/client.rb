require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'adobe/reactor/utils'
require 'logger'

module Adobe::Reactor
  class Client
    DEFAULTS = {
      accept_type: 'application/vnd.api+json',
      connection_timeout: 60,
      faraday_adapter: ::Faraday.default_adapter,
      host: 'localhost',
      logger: nil,
      logging_level: 'WARN',
      port: 9010,
      read_timeout: 60,
      scheme: 'http',
      ssl_verify: true,
      version: '1'
    }.freeze

    HEADERS = {
      'Content-Type': 'application/vnd.api+json',
      'User-Agent': "adobe-reactor-ruby/#{Adobe::Reactor::VERSION}".freeze,
    }.freeze
    DATA_FIELDS = ['type', 'attributes', 'id', 'links', 'relationships', 'meta'].freeze

    attr_reader :conn
    attr_accessor :api_key, :api_token, :config, :logger

    def initialize(api_key, api_token, options={})
      @api_key = api_key
      @api_token = api_token
      @config = DEFAULTS.merge options
      @conn = build_conn
    end

    def get(*chunks)
      response = @conn.get(chunks.join('/'))
      data = response.body['data']
      hydrate_resource(data)
    end

    def index(*chunks)
      response = @conn.get(chunks.join('/'))
      data = response.body['data']
      hydrate_resources(data)
    end

    def post(resource)
    end

    def patch(resource)
      payload = resource.serialized
      response = @conn.patch(resource.href, payload)
      data = response.body['data']
      hydrate_resource(data)
    end

    def delete(href)
      @conn.delete(href)
    end

    def hydrate_resources(data)
      data.map do |d|
        hydrate_resource(d)
      end
    end

    def hydrate_resource(data)
      hash = Utils.slice(data, *DATA_FIELDS)

      type_of = hash['type']
      klass = Object.const_get('Adobe::Reactor::' + Utils.classify(type_of))
      klass.new(hash)
    end




    def build_conn
      if config[:logger]
        @logger = config[:logger]
      else
        @logger = Logger.new(STDOUT)
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
      connection = Faraday.new(url, options) do |cxn|
        cxn.request  :json
        cxn.response :logger, logger
        # cxn.response :handle_balanced_errors
        cxn.response :json
        # cxn.response :raise_error  # raise exceptions on 40x, 50x responses
        cxn.adapter  config[:faraday_adapter]
      end
      connection.path_prefix = '/'
      build_headers(connection)
      connection
    end

    def build_headers(connection)
      connection.headers['Accept'] = "#{@config[:accept_type]};revision=#{@config[:version]}"
      connection.headers['Authorization'] = "Bearer #{api_token}"
      connection.headers['X-Api-Key'] = api_key
      connection.headers.merge!(HEADERS)
    end

    # keep?
     def url
       builder = (config[:scheme] == 'http') ? URI::HTTP : URI::HTTPS
       builder.build(
         :host => config[:host],
         :port => config[:port],
         :scheme => config[:scheme]
       )
     end
  end
end
