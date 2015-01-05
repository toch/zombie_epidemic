module ZombieEpidemic
  class Point
    attr_reader :neighborhood
    attr_accessor :contents
    
    def initialize
      @neighborhood = {
        north: nil,
        west: nil,
        south: nil,
        east: nil
      }
      
      @contents = nil
    end

    def empty?
      @contents.nil?
    end
  end
end