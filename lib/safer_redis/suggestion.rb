# frozen_string_literal: true

module SaferRedis
  class Suggestion
    attr_reader :command, :description

    def initialize(command, description)
      @command = command
      @description = description
    end

    def self.for_command(command)
      case command
      when "DEL"
        new(command, "Consider using the non-blocking UNLINK command instead to delete the key on a background thread")
      else
        nil
      end
    end
  end
end
