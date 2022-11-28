# frozen_string_literal: true

module SaferRedis
  module Interceptor
    def send_command(command, &block)
      SaferRedis.assess(command) unless SaferRedis.really?
      super
    end
  end
end
