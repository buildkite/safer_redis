# frozen_string_literal: true

module SaferRedis
  module Interceptor
    def send_command(command, &block)
      if SaferRedis.active?
        SaferRedis::Assessor.assess!(
          SaferRedis::CommandDoc.from_command_array(command),
          redis: self,
        )
      end

      super
    end
  end
end
