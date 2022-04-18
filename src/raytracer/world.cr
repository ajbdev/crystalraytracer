class World
  property objects : Array(Shape)
  property light : Lights::Point?

  def initialize
    @objects = [] of Shape
  end
  
  def intersect(ray : Ray)
    xs = Intersections.new(@objects.flat_map { |obj| obj.intersect(ray).items })
    xs.sort_by_distance!

    xs
  end

  def shade_hit(comps : Computations)
    comps.object.material.lighting(@light.not_nil!, comps.point, comps.eye_v, comps.normal_v)
  end

  def color_at(ray : Ray)
    xs = intersect(ray)

    return Color.black unless xs.hit?

    shade_hit(xs.hit.precompute(ray))
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