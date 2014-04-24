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

## Usage

First you must initialize the service layer:

    rails generate service_layer:initialize

Then you can create services as so:

    rails generate service_layer:service fulfillment

At this point you can open the service at app/services/fulfillment_service.rb and modify its content as appropriate

```ruby
module Services
  class FulfillmentService
    # TODO implement me
  end
end
```

After which the rest of your app can declare their dependence on services using the ```ServiceLayer::Dependent``` module and
its ```services``` macro:

```ruby
class OrderService < ActiveRecord::Base
  extend ServiceLayer::Dependent
  services :billing_service, :fulfillment_service

  def finish(order)
    billing_service.bill_for(order)
    fulfillment_service.fulfill(order)
    order.update_attributes!(status: 'FINISHED')
  end
end
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

## More examples
The can be found in the demo rails project.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/service_layer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
