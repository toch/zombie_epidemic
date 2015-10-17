require_relative "void"

module ZombieEpidemic
  class Point
    attr_reader :neighborhood
    attr_accessor :contents

    def self.create_void
      void_point = point_klass.new
      [:north, :east, :south, :west].each do |direction|
        void_point.neighborhood[direction] = void_point
      end
      void_point
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
  end
end
