require_relative '../spec_helper'

FakeRandom = Struct.new("FakeRandom", :result) do
  def initialize(result = 0)
    super
    @result = result
  end
  def rand(max)
    @result
  end
end

describe ZombieEpidemic::StateTransitionMachine do
  subject                   { ZombieEpidemic::StateTransitionMachine.new(FakeRandom) }

  class Agent
    attr_accessor :position, :state, :state_age, :current_action
    def initialize(options = {})
      @position = options[:position]
      @state = options[:state]
      @state_age = options[:state_age]
      @current_action = options[:current_action]
    end
  end

  let(:void)                { Class.new{ def method_missing(*args, &block); self; end }.new }
  let(:void_point)          { OpenStruct.new(contents: void) }
  let(:empty_neighborhood)  { {north: void_point, south: void_point, east: void_point, west: void_point} }
  let(:point)               { OpenStruct.new(neighborhood: empty_neighborhood, empty?: false) }
  let(:agent)               { Agent.new(position: point, state: subject.states[:susceptible], state_age: 0) }
  let(:zombie)              { Agent.new(state: subject.states[:zombie], current_action: :fight)}

  it 'returns most of the time (90%) susceptible as a default state' do
    subject.instance_variable_set("@prng", FakeRandom.new(11))
    subject.reload
    subject.default_state.must_equal subject.states[:susceptible]
  end

  it 'returns sometimes (10%) zombie as a default state' do
    subject.default_state.must_equal subject.states[:zombie]
  end

  it 'has a susceptible state' do
    subject.states[:susceptible].wont_be_nil
  end

  it 'has an infected state' do
    subject.states[:infected].wont_be_nil
  end

  it 'has a zombie state' do
    subject.states[:zombie].wont_be_nil
  end

  it 'has a dead state' do
    subject.states[:dead].wont_be_nil
  end

  it 'doesn\'t imply infection when no infection' do
    subject.states[:susceptible].trigger_transition(agent).must_equal subject.states[:susceptible]
  end

  it 'implies infection when bitten by a zombie' do
    subject.instance_variable_set("@prng", FakeRandom.new(9))
    subject.reload
    empty_neighborhood[:north] = OpenStruct.new(empty?: false, contents: zombie)
    subject.states[:susceptible].trigger_transition(agent).must_equal subject.states[:infected]
  end

  it 'doesn\'t imply death when no attacks' do
    [:susceptible, :infected, :zombie].each do |state_name|
      subject.states[state_name].trigger_transition(agent).must_equal subject.states[state_name]
    end
  end

  it 'implies death when severely attacked by another zombie' do
    empty_neighborhood[:north] = OpenStruct.new(empty?: false, contents: zombie)
    [:susceptible, :infected].each do |state_name|
      subject.states[state_name].trigger_transition(agent).must_equal subject.states[:dead]
    end
  end

  it 'implies death when severely attacked by another alive agent' do
    agent.current_action = :fight
    empty_neighborhood[:north] = OpenStruct.new(empty?: false, contents: agent)
    zombie.position = OpenStruct.new(neighborhood: empty_neighborhood, empty?: false)
    subject.states[:zombie].trigger_transition(zombie).must_equal subject.states[:dead]
  end

  it 'doesn\'t imply a zombification when ongoing incubation' do
    subject.states[:infected].trigger_transition(agent).must_equal subject.states[:infected]
  end

  it 'implies a zombification when finished incubation' do
    agent.state_age = 3601
    subject.states[:infected].trigger_transition(agent).must_equal subject.states[:zombie]
  end

end
