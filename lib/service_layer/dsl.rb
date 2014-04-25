module ServiceLayer
  ##
  # Context for evaluating a service layer DSL used to map and build services if you
  # need to go beyond the easy case of auto detection.
  class DSL
    ##
    # Looks up a service by a given key
    def service(key)
      Locator.lookup(key)
    end

    ##
    # Maps a service to a key.  Shortcut for Locator.register
    def map(key, service)
      Locator.register(key, service)
    end
  end
end
