# frozen_string_literal: true

module SaferRedis
  class Command
    # The `redis` gem represents commands internally as an array with the command name
    # as a lower-case symbol as the first item, e.g. [:del, "foo", "bar"]
    def self.from_array(a)
      new(a.first.to_s.upcase)
    end

    def initialize(name)
      @name = name
    end

    attr_reader :name

    def url
      slug = name.downcase.gsub(" ", "-")

      "https://redis.io/commands/#{slug}/"
    end
  end
end
