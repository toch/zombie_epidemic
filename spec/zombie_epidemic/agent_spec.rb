require_relative '../spec_helper'

describe ZombieEpidemic::Agent do
  let(:point)     { OpenStruct.new }
  let(:map)       {
                    OpenStruct.new(free_random_position: point).tap do |obj|
                      obj.define_singleton_method(:neighborhood_of) do |_|
                        { north: OpenStruct }
                      end
                    end
                  }
  let(:north_pt)  { map.neighborhood_of(point)[:north] }
  let(:stm)       { OpenStruct.new(default_state: :susceptible) }
  subject         { ZombieEpidemic::Agent.new(map, stm) }

  it 'has a position' do
    subject.position.must_equal point 
  end

  it 'has a health state' do
    subject.state.must_equal stm.default_state
  end

  it 'can walk' do    
    subject.walk(:north)
    subject.position.must_equal north_pt
  end

end