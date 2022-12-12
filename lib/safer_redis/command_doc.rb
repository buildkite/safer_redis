# frozen_string_literal: true

require "json"

module SaferRedis
  class CommandDoc
    CATEGORY_SLOW = "@slow"
    CATEGORY_DANGEROUS = "@dangerous"

    # JSON-parsed Redis command data from the embedded copy of
    # https://github.com/redis/redis-doc/blob/master/commands.json
    def self.commands_data
      @commands_data ||= begin
        base_dir = File.absolute_path(File.join(__dir__, "..", ".."))
        path = File.join(base_dir, "data", "redis-doc", "commands.json")

        JSON.parse(File.read(path))
      end
    end

    # The `redis` gem represents commands internally as an array with the command name
    # as a lower-case symbol as the first item, e.g. [:del, "foo", "bar"]
    def self.from_command_array(a)
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

    def slow?
      acl_categories.include?(CATEGORY_SLOW)
    end

    def dangerous?
      acl_categories.include?(CATEGORY_DANGEROUS)
    end

    def acl_categories
      command.fetch("acl_categories", [])
    end

    def complexity
      command.fetch("complexity", nil)
    end

    def suggestion
      Suggestion.for_command(name)
    end

    private

    def command
      @command ||= (self.class.commands_data[name] || {})
    end
  end
end
