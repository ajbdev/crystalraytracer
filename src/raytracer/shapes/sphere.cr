
class Sphere < Shape
  def intersect(ray : Ray)
    ray = ray.transform(transform.inverse)
    sphere_to_ray = ray.origin - Point.new(0,0,0)
    a = ray.direction.dot(ray.direction)
    b = 2 * ray.direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1

    discriminant = b * b - 4 * a * c

    return Tuple.new if discriminant < 0
      
    t1 = ((-1 * b) - Math.sqrt(discriminant)) / (2 * a)
    t2 = ((-1 * b) + Math.sqrt(discriminant)) / (2 * a)

    return Intersections.new t1, t2, object: self
  end
end