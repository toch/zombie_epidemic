module ZombieEpidemic
  class Agent
    attr_reader :state, :position, :state_age, :current_action
    def initialize(map, stm)
      @state = stm.default_state
      @new_state = @state
      @state_age = 0
      @position = map.free_random_position
      @new_position = @position
      @position.contents = self
      @current_action = :stay
    end

    def walk(direction)
      @new_position = neighborhood[direction] unless direction.nil?
    end

    def perceive
      neighborhood.map do |direction, position|
        position.nil? ? nil : [direction, position.contents]
      end.compact.to_h
    end

    def act
      @current_action = @state.decide_action_for(self)
      if @current_action == :walk
        neighbors = perceive
        unless neighbors.empty?
          walk(neighbors.keys.sample) 
        else
          @current_action = :stay
        end
      end
      @current_action
    end

    def age
      @new_state = state.trigger_transition(self)
      @state_age += 1
    end

    def commit
      if @new_position.empty?
        @position.contents = nil
        @position = @new_position
        @position.contents = self
      end
      @state_age = 0 if @new_state != @state
      @state = @new_state
    end

    private
    def neighborhood
      @position.neighborhood
    end
  end
end