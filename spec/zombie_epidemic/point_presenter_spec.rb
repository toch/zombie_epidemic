require_relative '../spec_helper'

FakePoint = Struct.new("PointPresenter", :contents) do
  def empty?
    contents.nil?
  end
end

describe ZombieEpidemic::PointPresenter do
  let(:state) { OpenStruct.new(name: :susceptible) }
  let(:agent) { OpenStruct.new(state: state) }
  let(:point) { FakePoint.new(nil) }
  subject     { ZombieEpidemic::PointPresenter.new }

  it 'colors the point as grey if empty' do
    subject.render(point).must_equal :grey
  end

  it 'colors the point as green if contains susceptible' do
    point.contents = agent
    subject.render(point).must_equal :green
  end

  it 'colors the point as yellow if contains infected' do
    point.contents = agent
    state.name = :infected
    subject.render(point).must_equal :yellow
  end

  it 'colors the point as red if contains zombie' do
    point.contents = agent
    state.name = :zombie
    subject.render(point).must_equal :red
  end

  it 'colors the point as black if contains dead or something else' do
    point.contents = agent
    state.name = :dead
    subject.render(point).must_equal :black
  end

end