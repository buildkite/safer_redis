# frozen_string_literal: true

module SaferRedis
  module Interceptor
    def send_command(command, &block)
      if SaferRedis.active?
        SaferRedis.assess!(SaferRedis::CommandDoc.from_command_array(command))
      end

      super
    end
  end
end
