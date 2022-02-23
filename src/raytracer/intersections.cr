class Intersections
  include Indexable(Intersection)

  def initialize(intersections : Array(Intersection) = [] of Intersection)
    @intersections = intersections
  end

  def each(&block)
    @intersections.each(&block)
  end

  def size
    @intersections.size
  end

  def unsafe_fetch(index : Int)
    @intersections.unsafe_fetch(index)
  end
end