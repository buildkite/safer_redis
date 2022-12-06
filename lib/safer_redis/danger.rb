# frozen_string_literal: true

module SaferRedis
  class Danger < Error
    def initialize(doc)
      message = <<~MESSAGE
        The #{doc.name} Redis command might be dangerous.

        #{doc.url}

        ACL categories: #{doc.acl_categories.join(" ")}

        Complexity: #{doc.complexity}

        If you're sure this is okay, you can try again within `SaferRedis.really { ... }`
      MESSAGE

      unless doc.suggestion.nil?
        message = <<~MESSAGE
          #{message}
          Suggestion: #{doc.suggestion.description}
        MESSAGE
      end

      super(message)
    end
  end
end
