require_relative "void"

module ZombieEpidemic
  class Point
    attr_reader :neighborhood
    attr_accessor :contents

    def self.create_border
      return @@border_point if @@border_point
      @@border_point = Point.new
      [:north, :east, :south, :west].each do |direction|
        @@border_point.neighborhood[direction] = @@border_point
      end
      @@border_point.contents = Border.new
      @@border_point
    end

    def initialize
      @neighborhood = {
        north: nil,
        west: nil,
        south: nil,
        east: nil
      }

      @contents = Void.new
    end

    def empty?
      @contents.nil?
    end

    def clear
      @contents = Void.new
    end
    private
    @@border_point = nil
  end
end
