# Ensure all services defined in app/services are loaded and registered
Dir.glob(Rails.root.join('app', 'services', '**/*.rb')).each do |file|
  load file
end

# Collect all services defined in the Service module namespace
ServiceLayer.collect_services!

# You can register services explicitly here as follows:
# ServiceLayer::Locator.register(:foo, Object)
