class Plane < Shape
  def intersect(ray : Ray)
    return Intersections.new if ray.direction.y.abs < CTuple::EPSILON

    t = -ray.origin.y / ray.direction.y

    Intersections.new([Intersection.new(t, self)])
  end

  def normal_at(p : CTuple)
    Vector.new(0,1,0)
  end
end