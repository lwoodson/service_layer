module ServiceLayer
  class Railtie < Rails::Railtie
    gem_dir = Gem::Specification.find_by_name('service_layer').gem_dir
    rake_tasks do
      load File.join(gem_dir, 'lib', 'service_layer', 'tasks.rb')
    end
    generators do
      load File.join(gem_dir, 'lib', 'service_layer', 'service_generator.rb')
      load File.join(gem_dir, 'lib', 'service_layer', 'initialize_generator.rb')
    end
  end
end
