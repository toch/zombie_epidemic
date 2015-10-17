require_relative "check_position_content"
module ZombieEpidemic
  module StateTransitionMachineDefinition
    def self.states(states)
      fetch_state(states, :susceptible).define_action(
        ->(agent) {
          [:walk, :stay, :fight].sample
        }
      )
      fetch_state(states, :infected).define_action(
        ->(agent) {
          [:walk, :stay, :fight].sample
        }
      )
      fetch_state(states, :zombie).define_action(
        ->(agent) {
          [:walk, :fight].sample
        }
      )
      fetch_state(states, :dead)
    end

    def self.transitions(states, prng)
      states[:susceptible].add_transition(
        states[:infected],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return check(position) \
                     .has_an(:agent) \
                     .is(:zombie) \
                     .is(:fighting) \
                     .to_b &&
                   prng.rand(100) < 10
          end
          false
        }
      )

      states[:infected].add_transition(
        states[:zombie],
        ->(state, agent) {
          agent.state_age > 3_600
        }
      )

      states[:susceptible].add_transition(
        states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return check(position) \
                     .has_an(:agent) \
                     .is(:zombie) \
                     .is(:fighting) \
                     .to_b &&
                   prng.rand(100) < 1
          end
          false
        },
        10
      )


      states[:infected].add_transition(
        states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return check(position) \
                     .has_an(:agent) \
                     .is(:zombie) \
                     .is(:fighting) \
                     .to_b &&
                   prng.rand(100) < 10
          end
          false
        }
      )

      states[:zombie].add_transition(
        states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.each do |_, position|
            return check(position) \
                     .has_an(:agent) \
                     .is(:susceptible, :infected) \
                     .is(:fighting) \
                     .to_b &&
                   prng.rand(100) < 50
          end
          false
        }
      )
    end

    def self.default_state
      lambda do |states, prng|
        return states[:zombie] if prng.rand(100) < 10
        states[:susceptible]
      end
    end

    private
    extend CheckPositionContent

    def self.fetch_state(states, name)
      states[name] = State.new(name) unless states.has_key?(name)
      states[name]
    end
  end
end
