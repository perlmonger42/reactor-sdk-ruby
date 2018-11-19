require 'adobe/reactor/utils'

module Adobe::Reactor
  class Resource
    attr_accessor :attributes
    attr_accessor :id
    attr_accessor :href
    # connectivity (DONE)
    # read/show (DONE)
    # update (DONE))
    # delete (DONE))
    # utils (DONE))
    #   pagination
    #   filters
    #   sort
    # tests
    #
    # index (done)
    # reload
    # create
    # auto url
    # errors
    # fill out resources
    # actions
    #   revise
    #   transition
    # attr_accessor :relationships?
    # attr_accessor :meta
    # refactor connection details
    # debug mode

    def initialize(attrs)
      attrs = Utils.hash_with_indifferent_access attrs
      @attributes = attrs[:attributes]
      @id = attrs[:id]
      @href = attrs.dig(:links, :self)
    end

    def href_base
    end

    def href_get
    end

    #def resource_nesting
    #  [:company]
    #end

    #def base_url
    #  chunks = []
    #  if url_resource_nesting.present?
    #    url_resource_nesting.each do |rn|
    #      method = build_method(rn)
    #      chunks << rn << send(method)
    #      companies/id/property
    #    end
    #  end
    #  chunks << type_of << id
    #end


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
      Utils.tableize(self.class.name)
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

    def respond_to?(method_name)
      @attributes.has_key?(method_name.to_s)
      # relationships
    end

    def serialized
      {
        data: {
          id: @id,
          type: type_of,
          attributes: @attributes
        }
      }
    end
  end
end
