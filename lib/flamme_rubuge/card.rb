module FlammeRubuge
  # :nodoc:
  class Card
    class InvalidCardTypeError < StandardError; end
    EXHAUSTION = :exhaustion
    attr_reader :number

    def initialize(number, type = nil)
      # raise InvalidCardTypeError unless (FlammeRubuge::Player::COLORS + [EXHAUSTION]).include?(type)
      raise InvalidCardTypeError unless type.nil? || type == EXHAUSTION
      @type = type
      @number = number
    end

    def exhaustion?
      @type == EXHAUSTION
    end

    def to_s
      "<Card: number = #{number}, type = #{@type}>"
    end
  end
end
