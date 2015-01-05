module ZombieEpidemic
  class State
    attr_reader :name
    def initialize(name, action_strategy = ->(agent){ :stay })
      @name = name
      @transitions = []
      @action_strategy = action_strategy
    end

    def add_transition(target, check, priority = 0)
      @transitions << [target, check, priority]
    end

    def trigger_transition(agent)
      targets = {}
      @transitions.each do |target, check, priority|
        targets[priority] = target if check.call(self, agent)
      end
      return self if targets.empty?
      targets.max_by{ |priority, _| priority }.last
    end

    def decide_action_for(agent)
      @action_strategy.call(agent)
    end
  end
end