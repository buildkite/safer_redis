# frozen_string_literal: true

RSpec.describe SaferRedis::Assessor do
  describe ".assess!" do
    it "raises Danger for DEL because it's @slow" do
      expect {
        SaferRedis::Assessor.assess!(SaferRedis::Command.new("DEL"))
      }.to raise_error(SaferRedis::Danger, <<~MESSAGE)
        The DEL Redis command might be dangerous.

        ACL categories: @keyspace @write @slow

        Complexity: O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).

        If you're sure this is okay, you can try again within `SaferRedis.really { ... }`
      MESSAGE
    end

    it "raises no error for TYPE because it's neither slow nor dangerous" do
      expect {
        SaferRedis::Assessor.assess!(SaferRedis::Command.new("TYPE"))
      }.to_not raise_error
    end
  end

  describe ".assess" do
    it "assesses DEL as slow, which is a warning" do
      command = SaferRedis::Command.new("DEL")
      assessment = SaferRedis::Assessor.assess(command)

      expect(assessment.slow?).to eq(true)
      expect(assessment.dangerous?).to eq(false)

      expect(assessment.warning?).to eq(true)

      expect(assessment.complexity).to eq(<<~STRING.chomp)
        O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).
      STRING
    end

    it "assesses TYPE as safe" do
      command = SaferRedis::Command.new("TYPE")
      assessment = SaferRedis::Assessor.assess(command)

      expect(assessment.slow?).to eq(false)
      expect(assessment.dangerous?).to eq(false)

      expect(assessment.warning?).to eq(false)

      expect(assessment.complexity).to eq("O(1)")
    end
  end
end
