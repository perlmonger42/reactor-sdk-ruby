require 'adobe/reactor/resources'

module Adobe::Reactor
  class Property < Resource

    def self.index(company_id)
      chunks = ['companies', company_id, type_of]
      Adobe::Reactor.client.index(chunks)
    end
  end
end
