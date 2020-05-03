module FlammeRubuge # :nodoc:
  require "forwardable"
  # A Square is a "row" on the track. This is the naming system that
  # the board game's rules use.
  class Square
    extend Forwardable
    class UnknownFeatureError < StandardError; end
    class InvalidLaneCountError < StandardError; end
    def_delegators :feature, :min_speed, :max_speed, :slipstream?

    # TODO: get lanes out of here. Interact with lanes only through Square
    # The pick_up method is, I think, the only thing that uses it
    attr_reader :feature, :lanes
    UPHILL = :Uphill
    DOWNHILL = :Downhill
    SUPPLY = :SupplyZone
    COBBLES = :Cobbles
    FEATURE_TYPES = [UPHILL, DOWNHILL, SUPPLY, COBBLES].freeze
    START = :start
    FINISH = :finish
    START_FINISH = [START, FINISH].freeze

    def initialize(params = {})
      load_feature(params[:feature])
      create_lanes(params[:lane_count])

      @start_finish = params[:start_finish] if START_FINISH.include?(params[:start_finish])
    end

    def start?
      @start_finish == START
    end

    def finish?
      @start_finish == FINISH
    end

    def lane_count
      @lanes.count
    end

    # return the first free lane, or nil if square is full
    def empty_lane
      @lanes.each do |lane|
        return lane if lane.empty?
      end
      nil
    end

    def empty?
      @lanes.all?(&:empty?)
    end

    def empty!
      @lanes.all?(&:empty!)
    end

    def occupied?
      !empty?
    end

    def cyclists
      @lanes.map(&:occupant).compact
    end

    def remove_cyclist(cyclist)
      @lanes.each do |lane|
        if lane.occupant == cyclist
          lane.empty!
          return true
        end
      end
    end

    private

    def create_lanes(lane_count)
      raise InvalidLaneCountError unless lane_count.is_a? Integer

      @lanes = []
      lane_count.times { @lanes << Lane.new }
    end

    def load_feature(feature)
      if feature
        raise UnknownFeatureError unless FEATURE_TYPES.include?(feature)

        @feature = Object.const_get("FlammeRubuge::#{feature}")
      else
        @feature = FlammeRubuge::FlatRoad
      end
    end
  end
end
