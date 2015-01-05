module ZombieEpidemic
  class StateTransitionMachine
    attr_reader :states
    def initialize(rand_klass = Random)
      @prng = rand_klass.new
      @states = {
        susceptible: State.new(
                       :susceptible,
                       ->(agent) {
                         [:walk, :stay, :fight].sample
                       }
                     ),
        infected: State.new(
                    :infected,
                    ->(agent) {
                      [:walk, :stay, :fight].sample
                    }
                  ),
        zombie: State.new(
                  :zombie,
                  ->(agent) {
                    [:walk, :fight].sample
                  }
                ),
        dead: State.new(:dead)
      }

      @states[:susceptible].add_transition(
        @states[:infected],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return true if
              position &&
              !position.empty? &&
              position.contents.state.name == :zombie &&
              position.contents.current_action == :fight &&
              @prng.rand(100) < 10
          end
          false
        }
      )

      @states[:infected].add_transition(
        @states[:zombie],
        ->(state, agent) {
          agent.state_age > 172_800
        }
      )

      @states[:susceptible].add_transition(
        @states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return true if
              position &&
              !position.empty? &&
              position.contents.state.name == :zombie &&
              position.contents.current_action == :fight &&
              @prng.rand(100) < 1
          end
          false
        },
        10
      )


      @states[:infected].add_transition(
        @states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return true if
              position &&
              !position.empty? &&
              position.contents.state.name == :zombie &&
              position.contents.current_action == :fight &&
              @prng.rand(100) < 10
          end
          false
        }
      )

      @states[:zombie].add_transition(
        @states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return true if
              position &&
              !position.empty? &&
              [:susceptible, :infected].include?(position.contents.state.name) &&
              position.contents.current_action == :fight &&
              @prng.rand(100) < 50
          end
          false
        }
      )
    end

    def default_state
      return @states[:zombie] if @prng.rand(100) < 10
      @states[:susceptible]
    end
  end
end