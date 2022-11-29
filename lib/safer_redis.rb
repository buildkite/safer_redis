# frozen_string_literal: true

require "zeitwerk"
Zeitwerk::Loader.for_gem.setup

module SaferRedis
  class Error < StandardError; end

  def self.activate!
    Redis.prepend(SaferRedis::Interceptor)
  end

  def self.really
    was = defined?(@really) ? @really : false
    @really = true
    yield
  ensure
    @really = was
  end

  def self.really?
    @really == true
  end

  def self.really!
    @really = true
  end
end
