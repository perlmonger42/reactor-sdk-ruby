require 'adobe/reactor/resources'

module Adobe::Reactor
  class Company < Resource
    def properties
      Adobe::Reactor::Property.index(@id)
    end
  end
end
