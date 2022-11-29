# frozen_string_literal: true

module SaferRedis
  class Danger < Error
    def initialize(command:, assessment:)
      message = <<~MESSAGE
        The #{command.name} Redis command might be dangerous.

        ACL categories: #{assessment.categories.join(" ")}

        Complexity: #{assessment.complexity}

        If you're sure this is okay, you can try again within `SaferRedis.really { ... }`
      MESSAGE

      super(message)
    end
  end
end
