# frozen_string_literal: true

RSpec.describe SaferRedis::Assessor do
  describe ".assess!" do
    it "raises Danger all the time for now" do
      expect {
        SaferRedis::Assessor.assess!(SaferRedis::Command.new)
      }.to raise_error(SaferRedis::Danger)
    end
  end
end
