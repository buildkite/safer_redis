# frozen_string_literal: true

RSpec.describe SaferRedis::Command do
  subject(:command) { SaferRedis::Command.new(name) }

  describe "url" do
    context "for DEL command" do
      let(:name) { "DEL" }

      it "derives expected URL" do
        expect(command.url).to eq("https://redis.io/commands/del/")
      end
    end
  end
end
