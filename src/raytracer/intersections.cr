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

  def items
    @intersections
  end

  def hit?
    sorted_by_distance.first?
  end

  def hit
    sorted_by_distance.first
  end

  def sorted_by_distance
    @intersections.select { |i| i.t > 0 }.sort { |a,b| a.t <=> b.t }
  end

  def sort_by_distance!
    @intersections = sorted_by_distance
  end

  def each(&block : Intersection -> _)
    @intersections.each(&block)
  end

  def size
    @intersections.size
  end

  def unsafe_fetch(index : Int)
    @intersections.unsafe_fetch(index)
  end
end