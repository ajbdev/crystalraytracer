describe World do
  describe "#new" do
    it "creates a new world with no objects or lights" do
      w = World.new
      w.objects.size.should eq 0
      w.light.should be_nil
    end
    pending "has a default world with objects and lights" do
      light = Lights::Point.new(Point.new(-10, 10, -10), Color.new(1, 1, 1))
      s1 = Sphere.new
      s1.material.color = Color.new(0.8, 1.0, 0.6)
      s1.material.diffuse = 0.7
      s1.material.specular = 0.2
      s2 = Sphere.new
      s2.transform = Transform.scale(0.5, 0.5, 0.5)

      w = World.default
      w.light.not_nil!.position.should eq light.position
      w.light.not_nil!.intensity.should eq light.intensity

      w.objects.size.should eq 2
      # Need to fix, class comparisons are not value comparisons
      # Possible refactor: change objects/shapes/ctuples into structs 
      # w.objects.should contain(s1)
      # w.objects.should contain(s2)
    end

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
end