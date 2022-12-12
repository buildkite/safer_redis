RSpec.describe SaferRedis::Suggestion do
  describe ".for_command" do
    it "has a suggestion for DEL" do
      suggestion = SaferRedis::Suggestion.for_command("DEL")

      expect(suggestion.description).to eq "Consider using the non-blocking UNLINK command instead to delete the key on a background thread"
    end

    it "has no suggestion for KEYS" do
      expect(SaferRedis::Suggestion.for_command("KEYS")).to be_nil
    end
  end
end
