# frozen_string_literal: true

module SaferRedis
  class Assessment
    CATEGORY_SLOW = "@slow"
    CATEGORY_DANGEROUS = "@dangerous"

    # @param categories [Array<String>] e.g. ["@slow", "@dangerous"]
    # @param complexity [String] e.g. "O(N) where N is the number of keys that will be removed ..."
    def initialize(categories:, complexity:)
      @categories = categories
      @complexity = complexity
    end

    attr_reader :categories
    attr_reader :complexity

    def warning?
      slow? || dangerous?
    end

    def slow?
      @categories.include?(CATEGORY_SLOW)
    end

    def dangerous?
      @categories.include?(CATEGORY_DANGEROUS)
    end
  end
end
