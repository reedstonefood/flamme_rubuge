require 'spec_helper'

describe FlammeRubuge::Cyclist do
  describe "normal cyclist" do
    let(:test_deck) { [2, 3, 4, 5, 6] }
    let(:test_sprinter) { FlammeRubuge::Cyclist.new(FlammeRubuge::Cyclist::SPRINTER, test_deck) }

    it "does the basic things right" do
      expect(test_sprinter.type).to eq(FlammeRubuge::Cyclist::SPRINTER)
    end

    it "#draw" do
      drawn_cards = test_sprinter.draw(4)
      expect(drawn_cards.size).to eq(4)
      expect(test_sprinter.deck_size).to eq(1)
    end

    it "recycles correctly" do
      drawn_cards = test_sprinter.draw(4)
      first_choice = drawn_cards.first
      test_sprinter.play(first_choice, drawn_cards[1..])
      expect(test_sprinter.deck_size).to eq(1)

      drawn_cards = test_sprinter.draw(4)
      expect(drawn_cards.size).to eq(4)
      second_choice = drawn_cards.first
      test_sprinter.play(second_choice, drawn_cards[1..])
      expect(test_sprinter.deck_size).to eq(0)
    end
  end
end
