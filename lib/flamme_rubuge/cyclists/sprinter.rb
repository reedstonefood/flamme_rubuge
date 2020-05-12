module FlammeRubuge
  # The sprinteur from the base game
  class Sprinter < Cyclist
    def initial_cards
      [2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 9, 9, 9]
    end

    def self.type
      :sprinteur
    end
  end
end
