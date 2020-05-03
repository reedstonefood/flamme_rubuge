require 'spec_helper'

describe FlammeRubuge::Lane do
  describe "empty lane" do
    let(:lane) { FlammeRubuge::Lane.new }

    it "can set an occupant" do
      lane.occupant = "Dave the Cyclist"
      expect(lane.occupant).to eq("Dave the Cyclist")
    end

    it "#occupied?" do
      expect(lane.occupied?).to eq(false)
    end

    it "#empty?" do
      expect(lane.empty?).to eq(true)
    end
  end

  describe "occupied lane" do
    let(:lane) { FlammeRubuge::Lane.new }
    before do
      lane.occupant = "Geraint Thomas"
    end

    it "can read the occupant" do
      expect(lane.occupant).to eq("Geraint Thomas")
    end

    it "#occupied?" do
      expect(lane.occupied?).to eq(true)
    end

    it "#empty?" do
      expect(lane.empty?).to eq(false)
    end

    it "Empty the square" do
      expect(lane.empty?).to eq(false)
      expect(lane.empty!).to eq(nil)
      expect(lane.empty?).to eq(true)
    end
  end
end
