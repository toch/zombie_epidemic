require 'chunky_png'
module ZombieEpidemic
  class MapPresenter
    def initialize(point_presenter_klass = PointPresenter)
      @point_presenter = point_presenter_klass.new
    end
    def render(map)
      width, height = [map.width, map.height]
      png = ChunkyPNG::Image.new(width, height)
      width.times.each do |x|
        height.times.each do |y|
          png[x,y] = ChunkyPNG::Color(@point_presenter.render(map.point(x, y)))
        end
      end
      png
    end
  end
end