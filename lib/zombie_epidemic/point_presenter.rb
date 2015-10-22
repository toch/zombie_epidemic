module ZombieEpidemic
  class PointPresenter
    def render(point)
      return :grey if point.empty?
      return :blue if point.contents.name == "Obstacle"
      return :green if point.contents.state.name == :susceptible
      return :yellow if point.contents.state.name == :infected
      return :red if point.contents.state.name == :zombie
      :black # dead or other
    end
  end
end
