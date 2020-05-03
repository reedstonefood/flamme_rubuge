require 'spec_helper'

describe FlammeRubuge::TrackBuilder do
  let(:player_count) { 2 }
  let(:boring_track) { FlammeRubuge::TrackBuilder.new(:"Boring Track", player_count).squares }
  it "returns expected Squares" do
    expect(boring_track.count).to eq(78)
    expect(boring_track.uniq.length).to eq(3)
    expect(boring_track.first[:lane_count]).to eq(2)
  end

  it "gives an input that Square can accept" do
    expect(FlammeRubuge::Square.new(boring_track.first).lane_count).to eq(2)
  end

  describe "5 player game" do
    let(:player_count) { 5 }
    it "has a wider start area" do
      expect(boring_track.first[:lane_count]).to eq(3)
    end
  end
end
