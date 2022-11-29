# frozen_string_literal: true

require "json"

module SaferRedis
  class Assessor
    def self.assess(command)
      info = command_info(command)

      categories = info.fetch("acl_categories", [])
      complexity = info.fetch("complexity", nil)

      Assessment.new(
        categories: categories,
        complexity: complexity,
      )
    end

    def self.assess!(command)
      assessment = assess(command)
      if assessment.warning?
        raise SaferRedis::Danger.new(command: command, assessment: assessment)
      end
    end

    def self.command_info(command)
      # is there a better way to get the gem's base dir?
      gem_dir = Gem::Specification.find_by_name("safer_redis").gem_dir

      path = File.join(gem_dir, "data", "redis-doc", "commands.json")

      @data ||= JSON.parse(File.read(path))

      @data[command.name] || {}
    end
  end
end
