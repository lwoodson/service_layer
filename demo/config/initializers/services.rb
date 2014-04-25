# Ensure all services defined in app/services are loaded and registered
Dir.glob(Rails.root.join('app', 'services', '**/*.rb')).each do |file|
  load file
end

# Collect all services defined in the Service module namespace
ServiceLayer.collect_services!

ServiceLayer.mappings do
  snippet_providers = [
    service(:github_service),
    service(:js_fiddle_service)
  ]
  map(:snippet_providers, snippet_providers)
end
