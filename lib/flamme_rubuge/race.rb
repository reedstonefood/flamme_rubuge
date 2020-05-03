module FlammeRubuge
  # A race, or game
  class Race
    class InvalidPlayerDetailsError < StandardError; end
    attr_reader :players, :track, :state

    # players_details looks like {name: "Bob", color: :red, cyclists: [sprinter, roller]}
    def initialize(player_details, track)
      validate_player_details(player_details)
      @players = []
      create_players(player_details)
      @track = track.map { |square| FlammeRubuge::Square.new(square) } # a valid track is an Array of Squares.
      @turns = [Turn.new(self)]
      @state = :undefined
    end

    def current_turn
      @turns.last
    end

    def next_turn
      new_turn = Turn.new(self)
      @turns << new_turn
      new_turn
    end

    def create_starting_grid(method, params = nil)
      if method == :random
        random_starting_grid
      elsif method == :strict_order
        assign_cyclists_to_startzone(params)
      else
        raise NotImplementedError, method
      end
    end

    private

    def create_players(player_details)
      player_details.each do |player|
        cyclists = player[:cyclists].map do |cyclist_type|
          Cyclist.new(cyclist_type, RaceConfig.initial_deck(cyclist_type))
        end
        players << Player.new(player[:color], player[:name], cyclists)
      end
    end

    def validate_player_details(player_details)
      player_details.each do |player|
        missing_keys = %i[name color cyclists] - player.keys
        raise InvalidPlayerDetailsError missing_keys unless missing_keys.empty?
      end
    end

    def random_starting_grid
      cyclists = @players.map(&:cyclists).flatten.shuffle
      assign_cyclists_to_startzone(cyclists)
    end

    def assign_cyclists_to_startzone(cyclists)
      startzone.each do |square|
        break if cyclists.empty?
        while (spare_lane = square.empty_lane)
          spare_lane.occupant = cyclists.shift
          break if cyclists.empty?
        end
      end
    end

    def startzone
      track.filter(&:start?).reverse
    end
  end
end
