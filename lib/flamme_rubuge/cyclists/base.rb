module FlammeRubuge
  # Base details that all cyclist files need to know about
  class Cyclist
    def type
      self.class.type
    end
  end
end
