module FlammeRubuge
  # A player has multiple cyclists
  class Player
    class UnknownColorError < StandardError; end
    COLORS = %i[red blue green white black pink].freeze
    attr_reader :cyclists, :color, :name

    def initialize(color, name, cyclists)
      raise UnknownColorError unless COLORS.include?(color)

      @cyclists = cyclists
      @color = color
      @name = name
      @cyclists.each do |cyclist|
        cyclist.assign_player(self)
      end
    end
  end
end
