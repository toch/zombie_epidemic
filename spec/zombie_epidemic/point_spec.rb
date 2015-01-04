require_relative '../spec_helper'

describe ZombieEpidemic::Point do
  subject { ZombieEpidemic::Point.new }
  
  it 'has no contents' do
    subject.contents.must_be_nil
  end

  it 'has an empty neighborhood' do
    subject.neighborhood.each do |direction, neighbor|
      neighbor.must_be_nil
    end
  end
end