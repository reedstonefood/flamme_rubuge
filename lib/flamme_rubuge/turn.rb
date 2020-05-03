module FlammeRubuge
  # store what everyone has played
  # for bonus marks, show what actually happened, eg played 3, moved 4
  class Turn
    attr_accessor :played_cards, :game
    def initialize(game)
      @played_cards = {} # format is { Cyclist: Card }
      @game = game
    end

    def movement
      @game.move_cyclists(played_cards)
    end

    def end
      @game.clean_up_cards(played_cards)
      @game.apply_slipstreaming
      # we play you can't get an exhaustion card if you've crossed the finish line
      immune_to_exhaustion = @game.check_finishers
      @game.assign_exhaustion_cards(immune_to_exhaustion)
      @game.remove_finished_cyclists
    end
  end

  # The act of playing a card will be done something like this:
  # current_turn.played_cards[cyclist] = cyclist.play(chosen, other)
end
