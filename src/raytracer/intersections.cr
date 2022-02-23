class Intersections
  include Indexable(Intersection)

  def initialize(intersections : Array(Intersection) = [] of Intersection)
    @intersections = intersections
  end

  def initialize(*intersections)
    @intersections = intersections.to_a
  end

  def initialize(*ts, object : Shape)
    @intersections = [] of Intersection 
    ts.each do |t|
      @intersections << Intersection.new(t, object)
    end
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