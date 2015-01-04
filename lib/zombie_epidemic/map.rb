module ZombieEpidemic
  class Map
    attr_reader :width, :height
    def initialize(width, height, point_klass = Point)
      @width = width
      @height = height
      @points = Array.new(width) { Array.new(height) { point_klass.new } }

      @points.each_with_index do |col, x|
        col.each_with_index do |pt, y|
          pt.neighborhood[:north] = (y > 0 ? @points[x][y - 1] : nil)
          pt.neighborhood[:east] = (x < width - 1 ? @points[x + 1][y] : nil)
          pt.neighborhood[:south] = (y < height - 1 ? @points[x][y + 1] : nil)
          pt.neighborhood[:west] = (x > 0 ? @points[x - 1][y] : nil)
        end
      end
    end

    def point(x, y)
      return nil if x < 0 || x > width - 1
      return nil if y < 0 || y > height - 1

      @points[x][y]
    end
  end
end