require_relative '../spec_helper'

FakePointPresenter2 = Struct.new("FakePointPresenter") do
  def render(point)
    :black
  end
end

FakeMap = Struct.new("FakeMap", :width, :height) do
  def point(x, y)
    Object.new
  end
end

describe ZombieEpidemic::MapPresenter do
  let(:map) { FakeMap.new(10, 10) }
  subject   { ZombieEpidemic::MapPresenter.new(FakePointPresenter2) }

  it 'renders a black png 10x10' do
    png = subject.render(map)
    10.times.each do |x|
      10.times.each do |y|
        png[x, y].must_equal 255
      end
    end
  end
end
