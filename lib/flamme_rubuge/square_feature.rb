module FlammeRubuge
  # Square features
  class FlatRoad
    def self.to_s
      "Flat road"
    end

    def self.max_speed
      nil
    end

    def self.min_speed
      nil
    end

    def self.slipstream?
      true
    end
  end

  # :nodoc:
  class Uphill < FlatRoad
    def self.to_s
      "Uphill"
    end

    def self.max_speed
      5
    end

    def self.slipstream?
      false
    end
  end

  # :nodoc:
  class Downhill < FlatRoad
    def self.to_s
      "Downhill"
    end

    def self.min_speed
      5
    end
  end

  # :nodoc:
  class Cobbles < FlatRoad
    def self.to_s
      "Cobbles"
    end

    def self.slipstream?
      false
    end
  end

  # :nodoc:
  class SupplyZone < FlatRoad
    def self.to_s
      "Supply zone"
    end

    def self.min_speed
      4
    end
  end
end
