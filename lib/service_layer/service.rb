module ServiceLayer
  module Service
    def self.included(klass)
      service_name = klass.to_s.underscore
      unless Locator.registered?(service_name)
        Locator.register(service_name, klass)
      end
    end
  end
end
