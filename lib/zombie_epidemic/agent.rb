module ZombieEpidemic
  class Agent
    attr_reader :state, :position
    def initialize(map, stm)
      @state = stm.default_state
      @position = map.free_random_position
      @neighborhood = map.neighborhood_of(@position)
    end

    def walk(direction)
      @position = @neighborhood[direction]
    end
  end
end