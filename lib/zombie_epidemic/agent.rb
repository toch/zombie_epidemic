module ZombieEpidemic
  class Agent
    attr_reader :state, :state_age, :current_action
    attr_accessor :position
    def initialize(start_position, stm)
      @state = stm.default_state
      @new_state = @state
      @state_age = 0
      @position = start_position
      @new_position = @position
      @position.contents = self
      @current_action = @state.decide_action_for(self)
    end

    def walk(direction)
      return if direction.nil?
      return unless neighborhood[direction].empty?
      @new_position = neighborhood[direction]
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
      move
      @state_age = 0 if @new_state != @state
      @state = @new_state
    end

    def unposition
      @position.clear
      @position = nil
    end

    def name
      self.class.name.split("::").last
    end

    private
    def neighborhood
      @position.neighborhood
    end

    def move
      return unless @new_position
      return unless @new_position.empty?
      return unless @new_position != @position
      @position.clear
      @position = @new_position
      @position.contents = self
    end
  end
end
