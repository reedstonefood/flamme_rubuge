module FlammeRubuge
  # a Lane is a single square on the track; it's part of a Square
  class Lane
    attr_accessor :occupant
    def occupied?
      !empty?
    end

    def empty?
      @occupant.nil?
    end

    def empty!
      @occupant = nil
    end
  end
end
