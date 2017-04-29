require_relative "check_position_content"
module ZombieEpidemic
  module StateTransitionMachineDefinition
    def self.states(states)
      fetch_state(states, :infected).define_action(
        ->(agent) {
          [:walk, :stay, :fight].sample
        }
      )
      fetch_state(states, :zombie).define_action(
        ->(agent) {
          neighbors = agent.perceive
          return :fight unless neighbors.select{ |_, neighbor| neighbor.class.name.split("::").last == "Agent" && neighbor.state.name == :susceptible }.empty?
          [:walk, :fight].sample
        }
      )
      fetch_state(states, :dead)
    end

    def self.transitions(states, prng)
      states[:infected].add_transition(
        states[:zombie],
        ->(state, agent) {
          prng.rand(100) < 1
        }
      )

      states[:infected].add_transition(
        states[:zombie],
        ->(state, agent) {
          agent.position.neighborhood.map do |_, position|
            check(position) \
              .has_an(:agent) \
              .is(:zombie) \
              .is(:fighting) \
              .to_b &&
            prng.rand(100) < 50
          end.any?
        },
        10
      )

      states[:infected].add_transition(
        states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.map do |_, position|
            check(position) \
              .has_an(:agent) \
              .is(:zombie) \
              .is(:fighting) \
              .to_b &&
            prng.rand(100) < 10
          end.any?
        },
        10
      )

      states[:zombie].add_transition(
        states[:dead],
        ->(state, agent) {
          agent.position.neighborhood.map do |_, position|
            check(position) \
              .has_an(:agent) \
              .is(:susceptible, :infected) \
              .is(:fighting) \
              .to_b &&
            prng.rand(100) < 100
          end.any?
        }
      )
    end

    def self.default_state
      lambda do |states, prng|
        states[:infected]
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
