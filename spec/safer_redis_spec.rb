# frozen_string_literal: true

RSpec.describe SaferRedis do
  describe ".assess!" do
    it "raises Danger for DEL because it's @slow" do
      expect {
        SaferRedis.assess!(SaferRedis::CommandDoc.new("DEL"))
      }.to raise_error(SaferRedis::Danger, <<~MESSAGE)
        The DEL Redis command might be dangerous.

        https://redis.io/commands/del/

        ACL categories: @keyspace @write @slow

        Complexity: O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).

        If you're sure this is okay, you can try again within `SaferRedis.really { ... }`

        Suggestion: Consider using the non-blocking UNLINK command instead to delete the key on a background thread
      MESSAGE
    end

    it "raises Danger for KEYS because it's @dangerous and @slow" do
      expect {
        SaferRedis.assess!(SaferRedis::CommandDoc.new("KEYS"))
      }.to raise_error(SaferRedis::Danger, <<~MESSAGE)
        The KEYS Redis command might be dangerous.

        https://redis.io/commands/keys/

        ACL categories: @keyspace @read @slow @dangerous

        Complexity: O(N) with N being the number of keys in the database, under the assumption that the key names in the database and the given pattern have limited length.

        If you're sure this is okay, you can try again within `SaferRedis.really { ... }`
      MESSAGE
    end

    it "raises no error for TYPE because it's neither slow nor dangerous" do
      expect {
        SaferRedis.assess!(SaferRedis::CommandDoc.new("TYPE"))
      }.to_not raise_error
    end
  end

  it "has a version number" do
    expect(SaferRedis::VERSION).not_to be nil
  end
end
