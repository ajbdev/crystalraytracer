class Intersections
  include Indexable(Intersection)

  enum Boundary
    All
    Visible

    def visible?
      self == Visible
    end

    def all?
      self == All
    end
  end

  def initialize(intersections : Array(Intersection) = [] of Intersection)
    @intersections = intersections
  end

  def initialize(tvals : Array(Tuple(Float64, Shape)))
    @intersections = tvals.map do |val|
      Intersection.new(val[0], val[1])
    end
  end

  # def initialize(*intersections)
  #   @intersections = intersections.to_a
  # end

  def initialize(*ts, object : Shape)
    @intersections = [] of Intersection
    ts.each do |t|
      @intersections << Intersection.new(t, object)
    end
  end

  def items
    @intersections
  end

  def hit?(intersect_with : Boundary = Boundary::Visible)
    !hit(intersect_with).nil?
  end

  def hit(intersect_with : Boundary = Boundary::Visible)
    return sorted_by_distance.visible.fetch(0,nil) if intersect_with.visible?

    sorted_by_distance.fetch(0,nil)
  end

  def sorted_by_distance
    Intersections.new(@intersections.sort { |a,b| a.t <=> b.t })
  end

  def visible
    Intersections.new(@intersections.select { |i| i.t > 0 })
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