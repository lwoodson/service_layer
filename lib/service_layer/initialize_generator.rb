module ServiceLayer
  class InitializeGenerator < Rails::Generators::Base
    desc "Set up the services layer for development"
    def create_services_directory
      service_dir = Rails.root.join("app", "services")
      empty_directory(service_dir)
      puts "Created #{service_dir}"
      service_init = Rails.root.join("config", "initializers", "services.rb")
      create_file service_init, <<-EOT
# Ensure all services defined in app/services are loaded and registered
Dir.glob(Rails.root.join('app', 'services', '**/*.rb')).each do |file|
  load file
end

# Collect all services defined in the Service module namespace
ServiceLayer.collect_services!

# You can register services explicitly here as follows:
# ServiceLayer::Locator.register(:foo, Object)
EOT
      puts "Created service initializer: #{service_init}"
    end
  end
end
