# EmberCLI Rails - Deploy Redis

[EmberCLI Rails] is an integration story between (surprise suprise) EmberCLI and
Rails 3.1 and up.

[ember-cli-deploy] is a simple, flexible deployment for your Ember CLI app.

[ember-deploy-redis] is the redis-adapter implementation to use Redis with ember-deploy.

`ember-cli-rails-deploy-redis` wires up all three.

[EmberCLI Rails]: https://github.com/rwz/ember-cli-rails
[ember-cli-deploy]: https://github.com/ember-cli/ember-cli-deploy
[ember-deploy-redis]: https://github.com/LevelbossMike/ember-deploy-redis

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ember-cli-rails-deploy-redis'
```

And then execute:

```bash
$ bundle
```

## Usage

The EmberCLI community recently unified the various deployment techniques into a
single, core-team supported project: [ember-cli-deploy][ember-cli-deploy].

This project attempts to streamline the process of pushing and serving
EmberCLI-built static assets.

To integrate with `ember-cli-deploy`'s ["Lightning Fast Deploys"][lightning]
(using the Redis adapter), instantiate an `EmberCLI::Deploy` in your controller:

```ruby
require "ember-cli/deploy"

class ApplicationController < ActionController::Base
  def index
    @deploy = EmberCLI::Deploy.new(namespace: "frontend")

    render text: @deploy.html, layout: false
  end
end
```

`EmberCLI::Deploy` takes a `namespace` (the name of your app declared in your
initializer) and handles all interaction with the Redis instance.

This is great for `staging` and `production` deploys, but introduces an extra
step in the feedback loop during development.

Luckily, `EmberCLI::Deploy` also accepts an `index_html` override, which will
replace the call to the Redis instance. This allows integration with the normal
`ember-cli-rails` workflow:

```ruby
require "ember-cli/deploy"

class ApplicationController < ActionController::Base
  def index
    @deploy = EmberCLI::Deploy.new(
      namespace: "frontend",
      index_html: index_html,
    )

    render text: @deploy.html, layout: false
  end

  private

  def index_html
    if serve_with_ember_cli_rails?
      render_to_string(:index)
    end
  end

  def serve_with_ember_cli_rails?
    ! %w[production staging].include?(Rails.env)
  end
end
```

Additionally, having access to the outbound HTML beforehand also enables
controllers to inject additional markup, such as metadata, CSRF tokens, or
analytics tags:


```ruby
require "ember-cli/deploy"

class ApplicationController < ActionController::Base
  def index
    @deploy = EmberCLI::Deploy.new(
      namespace: "frontend",
      index_html: index_html,
    )

    @deploy.append_to_head(render_to_string(partial: "my_csrf_and_metadata")
    @deploy.append_to_body(render_to_string(partial: "my_analytics")

    render text: @deploy.html, layout: false
  end
  # ...
end
```

[ember-cli-deploy]: https://github.com/ember-cli/ember-cli-deploy
[lightning]: https://github.com/ember-cli/ember-cli-deploy#lightning-approach-workflow

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ember-cli-rails-deploy-redis. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

