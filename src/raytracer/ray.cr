class Ray
  getter origin : Point
  getter direction : Vector

  def initialize(origin : Point, direction : Vector)
    @origin = origin
    @direction = direction
  end

  def position(t : Float64)
    origin + (direction * t)
  end
end