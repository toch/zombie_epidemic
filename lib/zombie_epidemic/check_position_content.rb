module ZombieEpidemic
  class PredicateOnPosition

    def initialize(position)
      @position = position
      @truth = !!position
    end

    def has_an(kind)
      return self unless @truth
      return self unless kind
      @truth = @position.contents.class.name == kind.to_s.capitalize
      self
    end

    def is(*something)
      return self unless @truth
      return self if something.empty?
      agent = @position.contents
      @truth = if something.first.to_s[-3..-1] == "ing"
        something.map{ |elem| elem.to_s[0..-4].to_sym }.include? agent.current_action
      else
        something.include? agent.state.name
      end
      self
    end

    def to_b
      @truth
    end
  end

  module CheckPositionContent
    def check(position)
      PredicateOnPosition.new(position)
    end
  end
end
