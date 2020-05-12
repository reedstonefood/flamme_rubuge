require 'spec_helper'

describe FlammeRubuge::Cyclist do
  describe "normal sprinter" do
    let(:test_sprinter) { FlammeRubuge::Sprinter.new }

    it "does the basic things right" do
      expect(test_sprinter.type).to eq(FlammeRubuge::Sprinter.type)
    end

    it "#draw" do
      drawn_cards = test_sprinter.draw(4)
      expect(drawn_cards.size).to eq(4)
      expect(test_sprinter.deck_size).to eq(11)
    end

    it "recycles correctly" do
      3.times do |index|
        drawn_cards = test_sprinter.draw(4)
        chosen_card = drawn_cards.first
        test_sprinter.play(chosen_card, drawn_cards[1..])
        expect(test_sprinter.deck_size).to eq(15 - ((index + 1) * 4))
      end

      drawn_cards = test_sprinter.draw(4)
      expect(drawn_cards.size).to eq(4)
      chosen_card = drawn_cards.first
      test_sprinter.play(chosen_card, drawn_cards[1..])
      expect(test_sprinter.deck_size).to eq(8) # 3 lots of 3 minus 1 needed for current hand
    end
  end

  describe "amended roller" do
    let(:extra_cards) { [FlammeRubuge::Card.new(2), FlammeRubuge::Card.new(2)] }
    let(:test_roller) { FlammeRubuge::Roller.new(extra_cards) }

    it "does the basic things right" do
      expect(test_roller.type).to eq(FlammeRubuge::Roller.type)
    end

    it "#draw" do
      drawn_cards = test_roller.draw(4)
      expect(drawn_cards.size).to eq(4)
      expect(test_roller.deck_size).to eq(13)
    end

    it "recycles correctly" do
      4.times do |index|
        drawn_cards = test_roller.draw(4)
        chosen_card = drawn_cards.first
        test_roller.play(chosen_card, drawn_cards[1..])
        expect(test_roller.deck_size).to eq(17 - ((index + 1) * 4))
      end

      drawn_cards = test_roller.draw(4)
      expect(drawn_cards.size).to eq(4)
      chosen_card = drawn_cards.first
      test_roller.play(chosen_card, drawn_cards[1..])
      expect(test_roller.deck_size).to eq(9) # 3 lots of 4 minus 3 needed for current hand
    end
  end
end
