# frozen_string_literal: true

RSpec.describe SaferRedis::CommandDoc do
  subject(:doc) { SaferRedis::CommandDoc.new(name) }

  describe "url" do
    context "for DEL" do
      let(:name) { "DEL" }

      it "derives expected URL" do
        expect(doc.url).to eq("https://redis.io/commands/del/")
      end
    end
  end

  describe "example commands" do
    it "assesses DEL as slow, which is a warning" do
      doc = SaferRedis::CommandDoc.new("DEL")

      expect(doc.slow?).to eq(true)
      expect(doc.dangerous?).to eq(false)

      expect(doc.complexity).to eq(<<~STRING.chomp)
        O(N) where N is the number of keys that will be removed. When a key to remove holds a value other than a string, the individual complexity for this key is O(M) where M is the number of elements in the list, set, sorted set or hash. Removing a single key that holds a string value is O(1).
      STRING
    end

    it "assesses TYPE as safe" do
      doc = SaferRedis::CommandDoc.new("TYPE")

      expect(doc.slow?).to eq(false)
      expect(doc.dangerous?).to eq(false)

      expect(doc.complexity).to eq("O(1)")
    end
  end

end
