module ZombieEpidemic
  class World
    def initialize(population_size = 10, map_klass = Map, agent_klass = Agent, stm_klass = StateTransitionMachine)
      @map = map_klass.new(10, 10)
      @stm = StateTransitionMachine.new
      @agents = []
      population_size.times { @agents << Agent.new(@map, @stm) }
      @time = 0
    end

    def run(steps = 24 * 3600 * 2 * 10)
      steps.times do
        @time += 1
        puts "Time: #{@time}"
        @agents.each_with_index do |agent, index|
          # puts "Agent #{index}: act"
          agent.act
          # puts "Agent #{index}: age"
          agent.age
        end
        @agents.each_with_index do |agent, index|
          # puts "Agent #{index}: commit"
          agent.commit
        end
        # puts "Delete dead agent"
        deads = @agents.delete_if { |agent| agent.state.name == :dead }
        # puts "Remove them from the map"
        deads.each { |dead| dead.position.contents = nil }
      end
    end
  end
end