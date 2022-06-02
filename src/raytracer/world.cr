class World
  property objects : Array(Shape)
  property light : Lights::Point?

  MAX_RECURSION_DEPTH = 5

  def initialize
    @objects = [] of Shape
  end
  
  def intersect(ray : Ray)
    xs = Intersections.new(@objects.flat_map(&.intersect(ray).items))
                      .sorted_by_distance

    xs
  end

  def shade_hit(comps : Computations, remaining : Int32 = MAX_RECURSION_DEPTH)
    return Color.black unless (light = @light)

    shadowed = shadowed?(comps.over_point)
    
    surface_color = comps.object.material.lighting(light,
                                                   comps.object,
                                                   comps.over_point,
                                                   comps.eye_v,
                                                   comps.normal_v,
                                                   shadowed)

    (surface_color + reflected_color(comps, remaining)).as_color
  end

  def color_at(ray : Ray, remaining : Int32 = MAX_RECURSION_DEPTH)
    xs = intersect(ray)

    return Color.black unless (hit = xs.hit())

    shade_hit(hit.precompute(ray), remaining)
  end

  def reflected_color(comps : Computations, remaining : Int32 = MAX_RECURSION_DEPTH)
    return Color.black if comps.object.material.reflective == 0
    return Color.black unless remaining > 0
    return Color.black unless (reflect_v = comps.reflect_v)

    reflect_ray = Ray.new(comps.over_point, reflect_v)
    color = color_at(reflect_ray, remaining - 1)

    (color * comps.object.material.reflective).as_color
  end

  def shadowed?(point : CTuple)
    return true unless (light = @light)

    v = light.position - point
    distance = v.magnitude
    direction = v.normalize
    r = Ray.new(point, direction)
    xs = intersect(r)
    
    return false unless (hit = xs.hit)

    hit.t < distance
  end

  def self.default
    w = World.new
    w.objects = [
      Sphere.new(
        material: Material.new(
          color: Color.new(0.8, 1.0, 0.6),
          diffuse: 0.7,
          specular: 0.2
        )
      ),
      Sphere.new(
        transform: Transform.scale(0.5,0.5,0.5)
      )
    ] of Shape
    w.light = Lights::Point.new(Point.new(-10, 10, -10), Color.white).not_nil!
    
    w
  end
end