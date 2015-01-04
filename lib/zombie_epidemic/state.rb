module ZombieEpidemic
  class State
    attr_reader :name
    def initialize(name)
      @name = name
      @transitions = []
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
  end
end