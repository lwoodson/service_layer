require "service_layer/version"
require "service_layer/locator"
require "service_layer/dependent"
require "service_layer/service"
require "service_layer/dsl"
require "service_layer/railtie" if defined?(Rails)

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module ServiceLayer
  def self.collect_services!
    if defined?(Services)
      Services.constants.each do |klass|
        if klass.to_s.end_with?("Service")
          service_class = Services.const_get(klass)
          Locator.register(klass.to_s.underscore, service_class)
        end
      end
      true
    else
      false
    end
  end

  def self.mappings(&block)
    dsl = DSL.new
    dsl.instance_exec(&block)
  end
end
