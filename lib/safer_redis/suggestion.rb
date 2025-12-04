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
        new(command, <<~END)
          Consider using the non-blocking UNLINK command instead to delete the key on a \
          background thread, or set the lazyfree-lazy-user-del server option.
        END
      when "KEYS"
        new(command, <<~END)
          KEYS blocks Redis until complete - avoid in production. Use SCAN instead, \
          which returns results incrementally.
        END
      when "SCAN", "SSCAN", "HSCAN", "ZSCAN"
        new(command, <<~END)
          A single SCAN call is usually enough to verify if keys exist. \
          If you must loop: use COUNT ≤100, add sleep between iterations.
        END
      else
        nil
      end
    end
  end
end
