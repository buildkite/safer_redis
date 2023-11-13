# frozen_string_literal: true

require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

module SaferRedis
  class Error < StandardError; end

  def self.activate!(klass: Redis)
    klass.prepend(SaferRedis::Interceptor)
    @active = true
  end

  def self.deactivate!
    @active = false
  end

  def self.active?
    defined?(@active) ? @active : false
  end

  def self.really
    was = active?
    @active = false
    yield
  ensure
    @active = was
  end
end
