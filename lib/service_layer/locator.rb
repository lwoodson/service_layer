module ServiceLayer
  ##
  # Raised if attempting to lookup a service by a key that has not been
  # registered against.
  class NotFoundError < StandardError
  end

  ##
  # Registry for services mapped to a key.  Allows lookup of services by their
  # key.
  class Locator
    @services = {}
    class << self
      ##
      # Registers a service klass against the specified key
      def register(key, klass)
        @services[key.to_sym] = klass
      end

      ##
      # Returns the keys for all the registered services
      def services
        @services.keys
      end

      ##
      # Looks up a service klass and instantiates it.
      def lookup(key, *args)
        service = @services[key.to_sym]
        raise NotFoundError, "No service keyed #{key}" unless service
        if service.is_a?(Class)
          service.new(*args)
        else
          service
        end
      end

      ##
      # True if the key is registered to a service or false otherwise.
      def registered?(key)
        @services.key?(key.to_sym)
      end

      ##
      # Resets the service locator map.
      def reset!
        @services.clear
      end
    end
  end
end
