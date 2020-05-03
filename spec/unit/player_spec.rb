require 'spec_helper'

describe FlammeRubuge::Player do
  describe "normal card" do
    let(:cyclist) { double(assign_player: nil) }
    let(:player) { FlammeRubuge::Player.new(:red, "Dave", [cyclist]) }

    it "returns expected values" do
      expect(player.name).to eq("Dave")
      expect(player.color).to eq(:red)
      expect(player.cyclists.count).to eq(1)
    end
  end
end
