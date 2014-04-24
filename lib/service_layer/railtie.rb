module ServiceLayer
  class Railtie < Rails::Railtie
    rake_tasks do
      gem_dir = Gem::Specification.find_by_name('service_layer').gem_dir
      load File.join(gem_dir, 'lib', 'service_layer', 'tasks.rb')
    end
  end
end
