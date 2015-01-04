require_relative '../spec_helper'

FakePoint = Struct.new("Point", :neighborhood) do |obj|
  def initialize(*)
    super
    self.neighborhood ||= {
        north: nil,
        west: nil,
        south: nil,
        east: nil
      }
  end

  def to_str
    "#{self.object_id}"
  end

  def inspect
    to_str
  end
end

describe ZombieEpidemic::Map do
  let(:width)   { 5 }
  let(:height)  { 5 }
  subject       { ZombieEpidemic::Map.new(width, height, FakePoint) }

  it 'builds the point (0, 0) in the left top corner' do
    expected = {
      north: nil,
      east: subject.point(1, 0),
      south: subject.point(0, 1),
      west: nil
    }
    subject.point(0, 0).neighborhood.must_equal expected
  end

  it 'builds the point (4, 0) in the right top corner' do
    expected = {
      north: nil,
      east: nil,
      south: subject.point(width - 1, 1),
      west: subject.point(width - 2, 0)
    }
    subject.point(width - 1, 0).neighborhood.must_equal expected
  end

  it 'builds the point (4, 4) in the right bottom corner' do
    expected = {
      north: subject.point(width - 1, height - 2),
      east: nil,
      south: nil,
      west: subject.point(width - 2, height - 1)
    }
    subject.point(width - 1, height - 1).neighborhood.must_equal expected
  end

  it 'builds the point (0, 4) in the right bottom corner' do
    expected = {
      north: subject.point(0, height - 2),
      east: subject.point(1, height - 1),
      south: nil,
      west: nil
    }
    subject.point(0, height - 1).neighborhood.must_equal expected
  end

  it 'has no point (-1, 0)' do
    subject.point(-1, 0).must_be_nil
  end

  it 'has no point (0, -1)' do
    subject.point(0, -1).must_be_nil
  end

  it 'has no point (5, 4)' do
    subject.point(5, 4).must_be_nil
  end

  it 'has no point (4, 5)' do
    subject.point(4, 5).must_be_nil
  end
end