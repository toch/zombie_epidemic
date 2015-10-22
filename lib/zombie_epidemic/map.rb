module ZombieEpidemic
  class Map
    attr_reader :width, :height, :border_point
    def initialize(width, height, point_klass = Point)
      @width = width
      @height = height
      @points = Array.new(width) { Array.new(height) { point_klass.new } }
      @free_positions = []

      @border_point = point_klass.create_border

      @points.each_with_index do |col, x|
        col.each_with_index do |pt, y|
          pt.neighborhood[:north] = (y > 0 ? @points[x][y - 1] : @border_point )
          pt.neighborhood[:east] = (x < width - 1 ? @points[x + 1][y] : @border_point )
          pt.neighborhood[:south] = (y < height - 1 ? @points[x][y + 1] : @border_point )
          pt.neighborhood[:west] = (x > 0 ? @points[x - 1][y] : @border_point )
          @free_positions << pt
        end
      end

      @free_positions.shuffle!
    end

    def point(x, y)
      return nil if x < 0 || x > width - 1
      return nil if y < 0 || y > height - 1

      @points[x][y]
    end

    def free_random_position
      @free_positions.pop
    end

  end
end
