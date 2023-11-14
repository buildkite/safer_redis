# SaferRedis

SaferRedis wraps a Redis connection, and warns you before letting through commands that could impact production availability by being marked `@slow` or `@dangerous` in the Redis documentation. It's intended to be activated in production `rails console` sessions, and perhaps one-off scripts or Rake tasks, but not for handling production workload.

Inspiration is taken from https://github.com/ankane/strong_migrations which provides similar guard-rails for potentially dangerous database migrations.

## Special cases

Commands tagged as `@slow` but with only O(1) complexity are not considered dangerous. This includes
e.g. the extremely commonly used `SET` command.

The [`DEL`](https://redis.io/commands/del/) command (`@slow`) is treated as [`UNLINK`](https://redis.io/commands/unlink/) (`@fast`) when the `lazyfree-lazy-user-del` server option is set.

## Limitations

Currently SaferRedis works with the [`redis` gem](https://rubygems.org/gems/redis) from https://github.com/redis/redis-rb (regardless of which connection adapter is being used, e.g. [`hiredis`](https://rubygems.org/gems/hiredis)) by hooking into the private `#send_command` method which was introduced in v4.6.0. This isn't a stable API, so other interception strategies will be considered and may be added in future. Some Redis connectors/drivers support middleware, but others don't.

Some commands are documented at the subcommand level as multiple words (e.g. `CLIENT LIST`). SaferRedis currently only recognises commands documented at their top-level single word (e.g. `DEL`). Support for multi-word commands will be considered and may be added in future.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add safer_redis

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install safer_redis

## Usage

```ruby
SaferRedis.activate!

redis = Redis.new

redis.del("very-large-collection")

# SaferRedis::Danger: The DEL Redis command might be dangerous.
#
# https://redis.io/commands/del/
#
# ACL categories: @keyspace @write @slow
#
# Complexity: O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).
#
# If you're sure this is okay, you can try again within `SaferRedis.really { ... }`

SaferRedis.really { redis.del("hello") }
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
