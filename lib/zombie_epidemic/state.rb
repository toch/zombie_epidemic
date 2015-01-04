module ZombieEpidemic
  class State
    attr_reader :name
    def initialize(name, action_strategy = ->(agent){ :stay })
      @name = name
      @transitions = []
      @action_strategy = action_strategy
    end

    def add_transition(target, check)
      @transitions << [target, check]
    end

    def trigger_transition(agent)
      @transitions.each do |target, check|
        return target if check.call(self, agent)
      end
      self
    end

    def decide_action_for(agent)
      @action_strategy.call(agent)
    end
  end
end