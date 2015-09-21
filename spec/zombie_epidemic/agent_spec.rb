require_relative '../spec_helper'

FakeState = Struct.new("State") do
  def trigger_transition(agent)
    self
  end

  def decide_action_for(agent)
    :stay
  end
end

describe ZombieEpidemic::Agent do
  let(:north_pt)  { OpenStruct.new(empty?: true) }
  let(:point)     do
                    Struct.new("Point", :neighborhood, :contents) do
                      def initialize(north_pt)
                        super
                        self.neighborhood = {north: north_pt}
                        self.contents = nil
                      end

                      def clear
                        self.contents = nil
                      end
                      def empty?
                        self.contents.nil?
                      end
                    end.new(north_pt)
                  end
  let(:map)       { OpenStruct.new(free_random_position: point) }
  let(:stm)       { OpenStruct.new(default_state: FakeState.new) }
  subject         { ZombieEpidemic::Agent.new(map.free_random_position, stm) }

  it 'has a position' do
    subject.position.must_equal point
    subject.position.contents.must_equal subject
  end

  it 'has a health state' do
    subject.state.must_equal stm.default_state
  end

  it 'can walk' do
    subject.walk(:north)
    subject.position.must_equal point
    subject.commit
    subject.position.must_equal north_pt
    north_pt.contents.must_equal subject
    point.contents.must_equal nil
  end

  it 'doesn\'t walk if no free positions around him' do
    subject.walk(nil)
    subject.position.must_equal point
    subject.commit
    subject.position.must_equal point
  end

  it 'ages' do
    state_age = subject.state_age
    subject.age
    subject.state.must_equal stm.default_state
    subject.commit
    subject.state.must_equal stm.default_state
    subject.state_age.must_equal state_age + 1
  end

  it 'acts' do
    subject.act.must_equal :stay
  end

  it 'perceives' do
    neigbors = {north: nil}
    subject.perceive.must_equal neigbors
  end
end
