# frozen_string_literal: true

require "json"

module SaferRedis
  class Assessor
    DATA_PATH = "data/redis-doc/commands.json"
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
      @data ||= JSON.parse(File.read(DATA_PATH))

      @data[command.name] || {}
    end
  end
end
