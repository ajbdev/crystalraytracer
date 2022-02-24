class Ray
  getter origin : Point
  getter direction : Vector

  def initialize(origin : Point, direction : Vector)
    @origin = origin
    @direction = direction
  end

  def initialize(origin : CTuple, direction : CTuple)
    @origin = origin.as Point
    @direction = direction.as Vector
  end

  def position(t : Float64)
    origin + (direction * t)
  end

  def transform(m : Matrix)
    ray = Ray.new(
      (self.origin * m).to_point,
      (self.direction * m).to_vector
    )

    ray
  end
end