require 'rake'
namespace :services do
  desc "List the registered services available to the app"
  task :ls => :environment do
    services = ServiceLayer::Locator.services.join(", ")
    puts "Services registered: #{services}"
  end
end
