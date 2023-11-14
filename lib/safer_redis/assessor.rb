# frozen_string_literal: true

require "json"

module SaferRedis
  class Assessor
    def self.assess!(doc, redis:)
      # DEL becomes UNLINK if lazyfree-lazy-user-del is set
      # https://github.com/redis/redis/pull/6243
      # https://redis.io/docs/management/config-file/
      if doc.name == "DEL" && config_get("lazyfree-lazy-user-del", redis:) == "yes"
        doc = SaferRedis::CommandDoc.new("UNLINK")
      end

      if doc.dangerous?
        # Anything tagged @dangerous is… dangerous
        raise SaferRedis::Danger.new(doc)

      elsif doc.slow? && doc.complexity != "O(1)"
        # Anything tagged @slow might be dangerous, but we'll let through O(1)
        # complexity commands e.g. SET
        raise SaferRedis::Danger.new(doc)
      end
    end

    def self.config_get(option, redis:)
      SaferRedis.really { redis.config(:get, option)[option] }
    end
  end
end
