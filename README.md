# ServiceLayer

Rails is very opinionated about MVC, but less so when the M gets beastly.  This gem adds opinionated
support for a [service layer](http://martinfowler.com/eaaCatalog/serviceLayer.html) whenever it makes
sense to bring into your growing rails application.  Here are some signs this might be the case:

* If your models are getting morbidly obese
* If you find yourself writing code that spans a lot of models that doesn't feel like it fits into any of them
* If you find yourself writing code that wraps one or more external APIs into some more complex operations within your domain
* If you find yourself with enough domain complexity that it seems like your domain is really a domain of domains
* If you find yourself writing something that could benefit from having parts of it being pluggable/configurable

## Installation

Add this line to your application's Gemfile:

    gem 'service_layer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install service_layer

## Basic Usage

First you must initialize the service layer:

    rails generate service_layer:initialize

Then you can create services as so:

    rails generate service_layer:service github

At this point you can open the service at app/services/github_service.rb and modify its content as appropriate

```ruby
module Services
  class GithubService
    # TODO implement me
  end
end
```

In the demo app, we implement this as so:

```ruby
module Services
  class GithubService
    include HTTParty
    base_uri 'https://api.github.com:443'
    format :json

    def initialize
      @options = {headers: {'User-Agent' => 'service_layer demo'}}
    end

    def source
      "GitHub"
    end

    def gists(username)
      self.class.get("/users/#{username}/gists", @options)
    end

    def number_of_snippets(username)
      gists(username).size
    end
  end
end
```

After which the rest of your app can declare their dependence on services using the ```ServiceLayer::Dependent``` module and
its ```services``` macro:

```ruby
class CollaboratesWithService
  extend ServiceLayer::Dependent
  services :github_service

  def test_connection
    !!github_service.gists('lwoodson')
  end
end
```

This collaborator can use the service it is dependent on however it sees fit.  To see this at work, cd into the demo directory and
run a rails console.

```
2.1.1 :001 > CollaboratesWithService.new.test_connection
 => true
```

## Service Mappings
Services are automagically mapped to their underscored class name as long as they are in the Services module namespace, as the following class in the demo app shows:

```ruby
module Services
  class JSFiddleService
    include HTTParty
    base_uri 'http://jsfiddle.net/api'

    def source
      "JSFiddle"
    end

    def fiddles(username)
      response = self.class.get("/user/#{username}/demo/list.json")
      JSON.parse(response.body)
    end

    def number_of_snippets(username)
      fiddles(username).size
    end
  end
end
```

```
lwoodson@dev:~/service_layer/demo$ bundle exec rails c
Loading development environment (Rails 4.1.0)
2.1.1 :001 > ServiceLayer::Locator.lookup(:js_fiddle_service)
 => #<Services::JSFiddleService:0x0000000598a2b0>
```

Services can be any object, however, and explictly mapped to a key as shown here (from demo/config/initializers/services.rb)

```
ServiceLayer.mappings do
  snippet_providers = [
    service(:github_service),
    service(:js_fiddle_service)
  ]
  map(:snippet_providers, snippet_providers)
end
```

In this case, ```snippet_providers``` is an array containing the github_service and the js_fiddle_service.  This allows for a pluggable aspect to service composition where that makes sense.  You can examine this using a rails console from the demo project.

```
lwoodson@dev:~/service_layer/demo$ bundle exec rails c
Loading development environment (Rails 4.1.0)
2.1.1 :001 > sps = ServiceLayer::Locator.lookup(:snippet_providers)
 => [#<Services::GithubService:0x00000000cf3af0 @options={:headers=>{"User-Agent"=>"service_layer demo"}}>, #<Services::JSFiddleService:0x00000000cf36b8>]

2.1.1 :002 > sps.map{|sp| sp.source}
 => ["GitHub", "JSFiddle"]
```

## Inter-Service Dependencies
Services can be dependent on other services, you simply need to have them extend ```ServiceLayer::Dependent``` and declare dependencies using the ```services ``` macro in the original example.

```ruby
module Services
  class SnippetsService
    extend ServiceLayer::Dependent
    services :snippet_providers

    def sources
      snippet_providers.map{|provider| provider.source}
    end

    def provider(source)
      snippet_providers.detect{|provider| provider.source == source}
    end

    def count(user, source="*")
      if source == "*"
        providers = snippet_providers
      else
        providers = [provider(source)]
      end

      providers.inject(0) do |result, provider|
        username = user.provider_account_data[provider.source]
        result += provider.number_of_snippets(username)
      end
    end
  end
end
```

You can test this from the demo app rails console:

```
lwoodson@dev:~/service_layer/demo$ bundle exec rails c
Loading development environment (Rails 4.1.0)
2.1.1 :001 > user = User.new provider_account_data: {"GitHub" => "lwoodson", "JSFiddle" => "lwoodson"}
 => #<User id: nil, name: nil, provider_account_data: {"GitHub"=>"lwoodson", "JSFiddle"=>"lwoodson"}, created_at: nil, updated_at: nil>

2.1.1 :002 > svc = Services::SnippetsService.new
 => #<Services::SnippetsService:0x00000005527600>

2.1.1 :003 > svc.count(user)
 => 13
```
## Conventions

Here are the opinionated conventions:

* Services should live in app/services.
* Services should be named "WhateverService"
* Services should be registered for future access using the underscored class name.  "WhateverService" becomes a key :whatever_service.
* Dependents on services must declare the services they will need for their operation using the ```services``` macro in ```ServiceLayer::Dependent```
* Services can be initialized with arguments to their accessors in dependent classes.  For example, a service accessor invoked as ```fulfillment_service(1,2,3)``` will instantiate the service class and pass 1, 2 and 3 as args to its constructor.

```ruby
  fulfillment_service(1, 2, 3)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/service_layer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
