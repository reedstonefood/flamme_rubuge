module FlammeRubuge
  # The rouleur from the base game
  class Roller < Cyclist
    def initial_cards
      [3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 6, 7, 7, 7]
    end

    def self.type
      :rouleur
    end
  end
end
