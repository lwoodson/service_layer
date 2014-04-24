module ServiceLayer
  class ServiceGenerator < Rails::Generators::Base
    desc "Create a service within the app/services directory"
    def create_service_file
      service_dir = Rails.root.join("app", "services")
      if Dir.exist?(service_dir)
        service_name = ARGV.first
        service_name = ask('Service name: ') unless service_name
        service_name = "#{service_name}Service" unless service_name.end_with?("Service")
        service_file = "#{service_name.underscore}.rb"
        create_file File.join(service_dir, service_file), <<-EOT
module Services
  class #{service_name.camelize}
  end
end
EOT
      else
        puts "ERROR:  It looks like you have yet to run 'rails generate service_layer:initialize'"
        Kernel.exit(-1)
      end
    end
  end
end
