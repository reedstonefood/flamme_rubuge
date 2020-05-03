module FlammeRubuge
  # The cyclist & associated deck of cards
  class Cyclist
    class UnknownCyclistTypeError < StandardError; end
    class InsufficientCardsError < StandardError; end
    class CardNotFoundError < StandardError; end
    class CyclistAlreadyHasPlayerError < StandardError; end

    attr_reader :type, :played, :player, :finish_position

    SPRINTER = :sprinteur
    ROLLER = :rouleur
    CYCLIST_TYPES = [SPRINTER, ROLLER].freeze

    def initialize(type, initial_cards)
      raise UnknownCyclistTypeError unless CYCLIST_TYPES.include?(type)
      @type = type
      @deck = []
      @played = []
      @discards = []
      setup_deck(initial_cards)
    end

    def setup_deck(initial_cards)
      return unless @deck.empty?

      initial_cards.each do |card_value|
        @deck << Card.new(card_value)
      end
      @deck.shuffle!
    end

    def assign_player(player)
      raise CyclistAlreadyHasPlayerError unless @player.nil?
      @player = player
    end

    def draw(requested_card_count)
      return @deck.pop(requested_card_count) if deck_size >= requested_card_count

      if deck_size + discards_size >= requested_card_count
        extra_cards_required = requested_card_count - deck_size
        remaining_deck = @deck.pop(deck_size)
        recycle
        return remaining_deck + @deck.pop(extra_cards_required)
      end
      raise InsufficientCardsError # need to implement exhaustion 2's in this case
    end

    # Just like in real life - return the played card & put others in the discard
    def play(chosen, discarded)
      @discards.push(*discarded)
      chosen
    end

    def deck_size
      @deck.count
    end

    def add_exhaustion
      @discards << Card.new(2, FlammeRubuge::Card::EXHAUSTION)
    end

    def finished?
      !finish_position.nil?
    end

    def set_finish_position(finish_position) # rubocop:disable Naming/AccessorMethodName
      @finish_position ||= finish_position # rubocop:disable Naming/MemoizedInstanceVariableName
    end

    def color
      @player.color
    end

    # required for tours
    def exhaustion_count
      (@deck.select(&:exhaustion?) + @discards.select(&:exhaustion?)).count
    end

    private

    def discards_size
      @discards.count
    end

    def recycle
      return if deck_size != 0 # or raise error?
      @deck.push(*@discards)
      @discards = []
      @deck.shuffle!
    end
  end
end
