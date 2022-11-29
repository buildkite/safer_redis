# frozen_string_literal: true

module SaferRedis
  class Command
    def initialize(name)
      @name = name
    end

    attr_reader :name
  end
end
