# frozen_string_literal: true

module SaferRedis
  class Command
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
