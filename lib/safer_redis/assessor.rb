# frozen_string_literal: true

module SaferRedis
  class Assessor
    def self.assess(command)
      Assessment.new
    end

    def self.assess!(command)
      if assess(command).warning?
        raise SaferRedis::Danger.new(command)
      end
    end
  end
end
