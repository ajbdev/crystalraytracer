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