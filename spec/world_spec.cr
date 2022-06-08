require "./spec_helper.cr"

describe World do
  describe "#new" do
    it "creates a new world with no objects or lights" do
      w = World.new
      w.objects.size.should eq 0
      w.light.should be_nil
    end
    it "has a default world with objects and lights" do
      light = Lights::Point.new(Point.new(-10, 10, -10), Color.new(1, 1, 1))
      s1 = Sphere.new
      s1.material.color = Color.new(0.8, 1.0, 0.6)
      s1.material.diffuse = 0.7
      s1.material.specular = 0.2
      s2 = Sphere.new
      s2.transform = Transform.scale(0.5, 0.5, 0.5)

      w = World.default

      next unless (light = w.light)

      light.position.should eq light.position
      light.intensity.should eq light.intensity

      w.objects.size.should eq 2
      # Need to fix, class comparisons are not value comparisons
      # Possible refactor: change objects/shapes/ctuples into structs
      # w.objects.should contain(s1)
      # w.objects.should contain(s2)
    end
  end
  describe "#intersect" do
    it "intersects a world with a ray" do
      w = World.default
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      xs = w.intersect(r)

      xs.size.should eq 4
      xs[0].t.should eq 4
      xs[1].t.should eq 4.5
      xs[2].t.should eq 5.5
      xs[3].t.should eq 6
    end
  end
  describe "#color_at" do
    it "the color when a ray misses" do
      w = World.default
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,1,0))
      c = w.color_at(r)
      c.should eq Color.new(0,0,0)
    end
    it "the color when a ray hits" do
      w = World.default
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      c = w.color_at(r)
      c.should eq Color.new(0.38066119308103435, 0.47582649135129296, 0.28549589481077575)
    end
    it "the color with an intersection behind the ray" do
      w = World.default
      outer = w.objects.first
      outer.material.ambient = 1
      inner = w.objects[1]
      inner.material.ambient = 1
      r = Ray.new(Point.new(0,0,0.75), Vector.new(0,0,-1))
      c = w.color_at(r)
      c.should eq inner.material.color
    end
    it "with mutually reflective surfaces" do
      w = World.new
      w.light = Lights::Point.new(Point.new(0,0,0),Color.new(1,1,1))
      lower = Plane.new
      lower.material.reflective = 1
      lower.transform = Transform.translate(0,1,0)
      w.objects << lower

      upper = Plane.new
      upper.material.reflective = 1
      upper.transform = Transform.translate(0,1,0)
      w.objects << upper

      r = Ray.new(Point.new(0,0,0), Vector.new(0,1,0))

      w.color_at(r).should be_truthy
    end
  end
  describe "#shadowed?" do
    it "there is no shadow when nothing is collinear with point and light" do
      w = World.default
      p = Point.new(0,10,0)
      w.shadowed?(p).should eq false
    end
    it "the shadow when an object is between the point and the light" do
      w = World.default
      p = Point.new(10,-10,10)
      w.shadowed?(p).should eq true
    end
    it "there is no shadow when an object is behind the light" do
      w = World.default
      p = Point.new(-20, 20, -20)
      w.shadowed?(p).should eq false
    end
    it "there is no shadow when an object is behind the point" do
      w = World.default
      p = Point.new(-2, 2, -2)
      w.shadowed?(p).should eq false
    end
  end
  describe "#shade_hit" do
    it "is given an intersection in shadow" do
      w = World.new
      w.light = Lights::Point.new(Point.new(0,0,-10),Color.new(1,1,1))
      
      s1 = Sphere.new
      w.objects << s1

      s2 = Sphere.new
      s2.transform = Transform.translate(0,0,10)

      w.objects << s2

      r = Ray.new(Point.new(0,0,5),Vector.new(0,0,1))
      i = Intersection.new(4, s2)

      comps = i.precompute(r)

      c = w.shade_hit(comps)
      c.should eq Color.new(0.1,0.1,0.1)
    end
    pending "with a reflective material" do
      w = World.default
      shape = Plane.new
      shape.material.reflective = 0.5
      shape.transform = Transform.translate(0,-1,0)

      w.objects << shape

      r = Ray.new(Point.new(0,0,-3),Vector.new(0,-Math.sqrt(2)/2, Math.sqrt(2)/2))
      i = Intersection.new(Math.sqrt(2), shape)

      comps = i.precompute(r)

      w.shade_hit(comps).should eq Color.new(0.87677, 0.92436, 0.82918)
    end
  end
  describe "#reflected_color" do
    it "the reflected color for a nonreflective material" do
      w = World.default
      r = Ray.new(Point.new(0,0,0), Vector.new(0,0,1))

      shape = w.objects[1]
      shape.material.ambient = 1.0

      i = Intersection.new(1, shape)
      comps = i.precompute(r)

      w.reflected_color(comps).should eq Color.new(0,0,0)
    end
    pending "the reflected color for a reflective material" do
      w = World.default

      shape = Plane.new
      shape.material.reflective = 0.5
      shape.transform = Transform.translate(0,-1,0)

      w.objects << shape

      r = Ray.new(Point.new(0,0,-3),Vector.new(0,-Math.sqrt(2)/2, Math.sqrt(2)/2))
      i = Intersection.new(Math.sqrt(2), shape)

      comps = i.precompute(r)

      w.reflected_color(comps).should eq Color.new(0.19032, 0.2379, 0.14274)
    end

    it "with a reflective material" do
      w = World.default
      shape = Plane.new
      shape.material.reflective = 0.5
      shape.transform = Transform.translate(0,-1,0)

      w.objects << shape

      r = Ray.new(Point.new(0,0,-3),Vector.new(0,-Math.sqrt(2)/2, Math.sqrt(2)/2))
      i = Intersection.new(Math.sqrt(2), shape)

      comps = i.precompute(r)

      w.reflected_color(comps, 0).should eq Color.black
    end
  end
  describe "#refracted_color" do
    it "with an opaque surface" do
      w = World.default
      shape = w.objects.first
      r = Ray.new(Point.new(0,0,-5),Vector.new(0,0,1))
      xs = Intersections.new([{4.0, shape},{6.0, shape}])
      comps = xs[0].precompute(r, xs)
      
      
      w.refracted_color(comps, 5).should eq Color.black
    end
    it "at the maximum recursion depth" do
      w = World.default
      shape = w.objects.first
      shape.material.transparency = 1.0
      shape.material.refractive_index = 1.5
      r = Ray.new(Point.new(0,0,-5),Vector.new(0,0,1))
      xs = Intersections.new([{4.0, shape},{6.0, shape}])
      comps = xs[0].precompute(r, xs)

      w.refracted_color(comps, 0).should eq Color.black
    end
    it "under total internal reflection" do
      w = World.default
      shape = w.objects.first
      shape.material.transparency = 1.0
      shape.material.refractive_index = 1.5
      r = Ray.new(Point.new(0,0,Math.sqrt(2)/2),Vector.new(0,1,0))
      xs = Intersections.new([{-Math.sqrt(2)/2, shape},{Math.sqrt(2)/2, shape}])
      comps = xs[0].precompute(r, xs)

      w.refracted_color(comps, 5).should eq Color.black
    end
  end
end