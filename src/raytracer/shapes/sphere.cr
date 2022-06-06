
class Sphere < Shape
  def intersect(ray : Ray)
    ray = ray.transform(transform.inverse)

    
    sphere_to_ray = ray.origin - Point.new(0,0,0)
    a = ray.direction.dot(ray.direction)
    b = 2 * ray.direction.dot(sphere_to_ray)
    c = sphere_to_ray.dot(sphere_to_ray) - 1

    discriminant = b * b - 4 * a * c

    return Intersections.new if discriminant < 0
      
    t1 = ((-1 * b) - Math.sqrt(discriminant)) / (2 * a)
    t2 = ((-1 * b) + Math.sqrt(discriminant)) / (2 * a)

    Intersections.new(t1, t2, object: self)
  end

  def normal_at(p : CTuple)
    object_point = transform.inverse * p
    object_normal = object_point - Point.new(0,0,0)

    world_normal = transform.inverse.transpose * object_normal
    world_normal.w = 0

    world_normal.normalize
  end

  def self.glass
    glassy_sphere = new
    glassy_sphere.material.transparency = 1.0
    glassy_sphere.material.refractive_index = 1.5

    glassy_sphere
  end
end