# frozen_string_literal: true

require_relative "lib/safer_redis/version"

Gem::Specification.new do |spec|
  spec.name = "safer_redis"
  spec.version = SaferRedis::VERSION
  spec.authors = ["Paul Annesley"]
  spec.email = ["paul@annesley.cc"]

  spec.summary = "Catch unsafe Redis commands in production"
  spec.description = "SaferRedis warns you before letting through commands that could impact production availability by being marked `@slow` or `@dangerous` in the Redis documentation"
  spec.homepage = "https://github.com/buildkite/safer_redis"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/buildkite/safer_redis"
  spec.metadata["changelog_uri"] = "https://github.com/buildkite/safer_redis/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  # The only strategy implemented so far is intercepting the private Redis#send_command method,
  # which was introduced in v4.6.0 via https://github.com/redis/redis-rb/pull/1058 and remains
  # in the latest release (v5.0.5) at time of writing.
  spec.add_dependency "redis", ">= 4.6.0"
  spec.add_dependency "zeitwerk"
end
