module ServiceLayer
  module Dependent
    def self.extended(base)
      base.send(:define_singleton_method, :services) do |*args|
        opts = args.last.is_a?(Hash) ? args.pop : nil
        args.each do |name|
          base.send(:define_method, name) do |*args|
            if opts && opts[:memoized]
              service = instance_variable_get("@#{name}")
              unless service
                service = ServiceLayer::Locator.lookup(name, *args)
                instance_variable_set("@#{name}", service)
              end
              service
            else
              ServiceLayer::Locator.lookup(name, *args)
            end
          end
        end
      end
    end 
  end
end
