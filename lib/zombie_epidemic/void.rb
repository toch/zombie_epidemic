module ZombieEpidemic
  class Void
    def nil?; true; end
    def method_missing(*args, &block)
      self
    end
  end
end
