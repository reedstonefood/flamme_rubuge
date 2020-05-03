require 'spec_helper'

describe FlammeRubuge::Square do
  describe "normal square" do
    let(:square) { FlammeRubuge::Square.new({ lane_count: 2 }) }

    it "returns expected results" do
      expect(square.lane_count).to eq(2)
      expect(square.max_speed).to eq(nil)
      expect(square.min_speed).to eq(nil)
      expect(square.slipstream?).to eq(true)
      expect(square.empty_lane).to be_a_kind_of(FlammeRubuge::Lane)
    end
  end

  describe "start square" do
    let(:square) { FlammeRubuge::Square.new({ lane_count: 3, start_finish: FlammeRubuge::Square::START }) }

    it "returns expected results" do
      expect(square.lane_count).to eq(3)
      expect(square.start?).to eq(true)
      expect(square.finish?).to eq(false)
    end
  end

  describe "uphill" do
    let(:square) { FlammeRubuge::Square.new({ lane_count: 3, feature: FlammeRubuge::Square::UPHILL }) }

    it "returns expected results" do
      expect(square.lane_count).to eq(3)
      expect(square.max_speed).to eq(5)
      expect(square.min_speed).to eq(nil)
      expect(square.slipstream?).to eq(false)
    end
  end

  describe "downhill" do
    let(:square) { FlammeRubuge::Square.new({ lane_count: 3, feature: FlammeRubuge::Square::DOWNHILL }) }

    it "returns expected results" do
      expect(square.lane_count).to eq(3)
      expect(square.max_speed).to eq(nil)
      expect(square.min_speed).to eq(5)
      expect(square.slipstream?).to eq(true)
    end
  end

  describe "supply zone" do
    let(:square) { FlammeRubuge::Square.new({ lane_count: 3, feature: FlammeRubuge::Square::SUPPLY }) }

    it "returns expected results" do
      expect(square.lane_count).to eq(3)
      expect(square.max_speed).to eq(nil)
      expect(square.min_speed).to eq(4)
      expect(square.slipstream?).to eq(true)
    end
  end

  describe "cobbles" do
    let(:square) { FlammeRubuge::Square.new({ lane_count: 1, feature: FlammeRubuge::Square::COBBLES }) }

    it "returns expected results" do
      expect(square.lane_count).to eq(1)
      expect(square.max_speed).to eq(nil)
      expect(square.min_speed).to eq(nil)
      expect(square.slipstream?).to eq(false)
    end
  end
end
