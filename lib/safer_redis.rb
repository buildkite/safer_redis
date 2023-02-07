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

  def self.assess!(doc)
    if doc.dangerous?
      # Anything tagged @dangerous is… dangerous
      raise SaferRedis::Danger.new(doc)

    elsif doc.slow? && doc.complexity != "O(1)"
      # Anything tagged @slow might be dangerous, but we'll let through O(1)
      # complexity commands e.g. SET
      raise SaferRedis::Danger.new(doc)
    end
  end
end
