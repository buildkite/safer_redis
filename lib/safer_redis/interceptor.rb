# frozen_string_literal: true

module SaferRedis
  module Interceptor
    def send_command(command, &block)
      unless SaferRedis.really?
        SaferRedis::Assessor.assess!(SaferRedis::Command.from_array(command))
      end
      super
    end
  end
end
