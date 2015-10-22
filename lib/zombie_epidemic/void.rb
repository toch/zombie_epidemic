module ZombieEpidemic
  class Void
    def nil?; true; end
    def method_missing(*args, &block)
      self
    end
  end

  class Border
    def nil?; false; end
    def method_missing(*args, &block)
      self
    end
  end

  class Obstacle
    def initialize(position)
      position.contents = self
    end
    def nil?; false; end
    def name; "Obstacle"; end
    def method_missing(*args, &block)
      self
    end
  end

end
