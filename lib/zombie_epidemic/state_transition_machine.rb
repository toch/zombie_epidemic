module ZombieEpidemic
  class StateTransitionMachine
    attr_reader :states
    def initialize(rand_klass = Random)
      @prng = rand_klass.new
      reload
    end

    def reload
      load_definition
      load_states
      load_transitions
      load_default_state
    end

    def default_state
      @default_state_fn.call(@states, @prng)
    end

    private

    def load_definition
      # load(File.join(File.dirname(File.expand_path(__FILE__)), "stm_definition.rb"))
      load(File.join(File.dirname(File.expand_path(__FILE__)), "stm_definition_walking_dead.rb"))
    end

    def load_states
      @states ||= {}
      ZombieEpidemic::StateTransitionMachineDefinition::states(@states)
    end

    def load_transitions
      ZombieEpidemic::StateTransitionMachineDefinition::transitions(@states, @prng)
    end

    def load_default_state
      @default_state_fn = ZombieEpidemic::StateTransitionMachineDefinition::default_state
    end
  end
end
