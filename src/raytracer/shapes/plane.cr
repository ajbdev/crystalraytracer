class Plane < Shape
  def intersect(ray : Ray)
    if ray.direction.y.abs < CTuple::EPSILON
      return Intersections.new
    end

    t = -ray.origin.y / ray.direction.y

    Intersections.new([Intersection.new(t, self)])
  end

  def normal_at(p : CTuple)
    Vector.new(0,1,0)
  end
end