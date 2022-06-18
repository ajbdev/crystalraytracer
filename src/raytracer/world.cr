class World
  property objects : Array(Shape)
  property light : Lights::Point?

  MAX_RECURSION_DEPTH = 5

  def initialize
    @objects = [] of Shape
  end

  def <<(s : Shape)
    @objects << s
  end
  
  def intersect(ray : Ray)
    xs = Intersections.new(@objects.flat_map(&.intersect(ray).items))
                      .sorted_by_distance

    xs
  end

  def shade_hit(comps : Computations, remaining : Int32 = MAX_RECURSION_DEPTH)
    return Color.black unless (light = @light) && (over_point = comps.over_point)

    shadowed = shadowed?(over_point)
    
    surface = comps.object.material.lighting(light,
                                             comps.object,
                                             over_point,
                                             comps.eye_v,
                                             comps.normal_v,
                                             shadowed)

    reflected = reflected_color(comps, remaining)
    refracted = refracted_color(comps, remaining)

    material = comps.object.material
    if material.reflective > 0 && material.transparency > 0
      reflectance = comps.calc_reflectance

      return (surface + reflected * reflectance + refracted * (1 - reflectance)).as_color
    end

    final = (surface + reflected + refracted).as_color

    final
  end

  def color_at(ray : Ray, remaining : Int32 = MAX_RECURSION_DEPTH)
    xs = intersect(ray)

    return Color.black unless (hit = xs.hit())

    comps = hit.precompute(ray)

    shade_hit(comps, remaining)
  end

  def reflected_color(comps : Computations, remaining : Int32 = MAX_RECURSION_DEPTH)
    return Color.black if comps.object.material.reflective == 0
    return Color.black unless remaining > 0
    return Color.black unless (reflect_v = comps.reflect_v) && (over_point = comps.over_point)

    reflect_ray = Ray.new(over_point, reflect_v)
    color = color_at(reflect_ray, remaining - 1)

    (color * comps.object.material.reflective).as_color
  end

  def refracted_color(comps, remaining)
    return Color.black if comps.object.material.transparency == 0 ||
                          remaining == 0
    return Color.black unless (n1 = comps.n1) && 
                              (n2 = comps.n2) && 
                              (under_point = comps.under_point)

    n_ratio = n1 / n2

    cos_i = comps.eye_v.dot(comps.normal_v)

    sin2_t = n_ratio ** 2 * (1 - cos_i ** 2)

    return Color.black if sin2_t > 1.0

    cos_t = Math.sqrt(1.0 - sin2_t)

    direction = comps.normal_v * (n_ratio * cos_i - cos_t) - comps.eye_v * n_ratio

    refract_ray = Ray.new(under_point, direction)

    color_at(refract_ray, remaining - 1) * comps.object.material.transparency
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
    
    w.light = Lights::Point.new(Point.new(-10, 10, -10), Color.white)
    
    w
  end
end