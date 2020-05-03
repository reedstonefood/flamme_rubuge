require 'spec_helper'

describe FlammeRubuge::Card do
  describe "normal card" do
    let(:card) { FlammeRubuge::Card.new(4) }

    it "#number" do
      expect(card.number).to eq(4)
    end

    it "#exhaustion?" do
      expect(card.exhaustion?).to eq(false)
    end
  end

  describe "exhaustion card" do
    let(:card) { FlammeRubuge::Card.new(2, FlammeRubuge::Card::EXHAUSTION) }

    it "#number" do
      expect(card.number).to eq(2)
    end

    it "#exhaustion?" do
      expect(card.exhaustion?).to eq(true)
    end
  end
end
