module FlammeRubuge
  # The configuration values to use for a race
  class RaceConfig
    def self.cyclist_types
      Cyclist::CYCLIST_TYPES
    end

    def self.initial_deck(cyclist_type)
      if cyclist_type == Cyclist::ROLLER
        [3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7]
      elsif cyclist_type == Cyclist::SPRINTER
        [2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 9, 9, 9]
      else
        []
      end
    end
  end
end
