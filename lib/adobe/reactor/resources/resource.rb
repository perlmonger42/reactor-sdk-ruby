module Adobe::Reactor
  class Resource
    attr_accessor :attributes
    attr_accessor :id
    attr_accessor :type_of
    attr_accessor :href
    # attr_accessor :meta
    # index
    #   pagination
    #   filters
    # reload
    # create
    # auto url
    # fill out resources
    # actions
    #   revise
    #   transition
    # relationships
    # errors


    def initialize(attrs)
      attrs = Utils.indifferent_read_access attrs
      @attributes = attrs[:attributes]
      @id = attrs[:id]
      @href = attrs.dig(:links, :self)
    end

    def href_base
    end
    def href_get
    end

    def resource_nesting
      [:company]
    end

    def self.get(href)
      Adobe::Reactor.client.get(href)
    end

    def self.index(href)
      Adobe::Reactor.client.index(href)
    end

    def save
      method = @href.nil? ? :post : :patch
      Adobe::Reactor.client.send(method, self)
    end

    def type_of
      'something'
    end

    def reload
    end

    def method_missing(method, *args, &block)
      return @attributes[method.to_s] if @attributes.has_key?(method.to_s)
      case method.to_s
      when /(.+)=$/
        attr = method.to_s.chop
        @attributes[attr] = args[0]
      else
        super
      end
    end

    def does_resource_respond_to?(method_name)
      @attributes.has_key?(method_name.to_s) or @hyperlinks.has_key?(method_name.to_s)
    end

    def serialized
      {
        data: {
          id: @id,
          type: 'companies',
          attributes: @attributes
        }
      }
    end
  end
end
