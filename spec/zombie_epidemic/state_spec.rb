require_relative '../spec_helper'

describe ZombieEpidemic::State do
  let(:name)  { 'state' }
  let(:state) { ZombieEpidemic::State.new('other') }
  subject     { ZombieEpidemic::State.new(name) }

  it 'has a name' do
    subject.name.must_equal name
  end

  it 'triggers a transition to another state when conditions met' do
    subject.add_transition(
      state,
      ->(_, _) { true }
    )

    subject.trigger_transition(Object.new).must_equal state
  end
end