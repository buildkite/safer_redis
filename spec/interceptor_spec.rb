# frozen_string_literal: true

require "redis"

RSpec.describe SaferRedis::Interceptor do

  class FakeRedis
    prepend SaferRedis::Interceptor

    def del(*keys)
      send_command([:del] + keys)
    end

    def type(key)
      send_command([:type, key])
    end

    private

    def send_command(command, &block)
      :actual
    end
  end

  let(:redis) { FakeRedis.new }

  it "lets through a safe command" do
    redis.type("hello")
  end

  it "intercepts a slow command" do
    expect {
      redis.del("hello")
    }.to raise_error(SaferRedis::Danger, /The DEL Redis command might be dangerous.*@slow.*O\(N\)/m)
  end

  it "can really run a slow command" do
    result = SaferRedis.really { redis.del("hello") }

    expect(result).to eq(:actual)
  end
end
