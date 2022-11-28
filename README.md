# SaferRedis

SaferRedis wraps a Redis connection, and warns you before letting through commands that could impact production availability by being marked `@slow` or `@dangerous` in the Redis documentation. It's intended to be activated in production `rails console` sessions, and perhaps one-off scripts or Rake tasks, but not for handling production workload.

Inspiration is taken from https://github.com/ankane/strong_migrations which provides similar guard-rails for potentially dangerous database migrations.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add safer_redis

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install safer_redis

## Usage

```ruby
# WIP: stay tuned for a nice way to activate it
Redis.prepend(SaferRedis::Shim)

redis = Redis.new

redis.del("very-large-collection")

# SaferRedis::Danger: This Redis command might be dangerous:
#
#   DEL very-large-collection
#
# If you're sure, try:
#
#   SaferRedis.really do
#     # your Redis call here
#   end
#
# from …/safer_redis.rb:43:in `assess'

SaferRedis.really { r.del("hello") }
# => 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buildkite/safer_redis. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/safer_redis/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SaferRedis project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/safer_redis/blob/master/CODE_OF_CONDUCT.md).
