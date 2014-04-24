require "service_layer/version"
require "service_layer/locator"
require "service_layer/dependent"
require "service_layer/service"

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
end
