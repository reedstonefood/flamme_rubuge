module FlammeRubuge
  # the track definitions.
  # It currently turns a short-form array of hashes, into stuff that can be fed directly
  # into Square
  class TrackBuilder
    class InvalidTrackNameError < StandardError; end
    attr_reader :squares
    DEFAULT_LANE_COUNT = 2

    # Valid keys:
    # repeat - how many squares
    # start_finish - valid values are :start and :finish
    # feature - valid values found in Square
    # min_players - this section only exists if there are at least this many players
    # other_lane_min_players - the number of lanes differs if there are more than this # of players
    # other_lane_count - as per above line, this is how many lanes there will be

    BORING_TRACK = [
      { repeat: 5, start_finish: :start, other_lane_count: 3, other_lane_min_players: 5 },
      { repeat: 68 },
      { repeat: 5, start_finish: :finish },
    ].freeze
    ONE_HILL = [
      { repeat: 5, start_finish: :start },
      { repeat: 20 },
      { repeat: 7, feature: FlammeRubuge::Square::UPHILL },
      { repeat: 3, feature: FlammeRubuge::Square::DOWNHILL },
      { repeat: 38 },
      { repeat: 5, start_finish: :finish },
    ].freeze
    TRACKS = {
      :"Boring Track" => BORING_TRACK,
      :"One Hill" => ONE_HILL,
    }.freeze

    def self.track_list
      TRACKS.keys
    end

    def initialize(track_name, player_count)
      raise InvalidTrackNameError unless TRACKS.keys.include?(track_name)

      @squares = []
      @player_count = player_count
      load_tracks(TRACKS[track_name])
    end

    def load_tracks(track_defintion)
      track_defintion.each do |row|
        next if @player_count < row.fetch(:min_players, 0)

        row[:repeat].times do
          squares << {
            lane_count: lane_count(row),
            feature: row[:feature],
            start_finish: row[:start_finish],
          }
        end
      end
    end

    private

    def lane_count(row)
      if row.fetch(:other_lane_min_players, 99) <= @player_count
        row[:other_lane_count]
      else
        row.fetch(:row_count, DEFAULT_LANE_COUNT)
      end
    end
  end
end
