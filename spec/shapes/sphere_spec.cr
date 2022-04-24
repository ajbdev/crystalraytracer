require "../spec_helper.cr"

describe Sphere do
  describe "#new" do
    it "ensures two spheres are not the same value" do
      a = Sphere.new
      b = Sphere.new
      
      a.should_not eq b
    end
  end
  describe "intersection" do
    it "ray intersects a sphere at two points" do
      r = Ray.new(Point.new(0, 0, -5), Vector.new(0, 0, 1))
      s = Sphere.new
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should_not be_nil
      xs.[1]?.should_not be_nil
      xs.[0]?.not_nil!.t.should eq 4.0
      xs.[1]?.not_nil!.t.should eq 6.0
    end
    it "ray intersects a sphere at a tangent" do
      r = Ray.new(Point.new(0, 1, -5), Vector.new(0, 0, 1))
      s = Sphere.new
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should_not be_nil
      xs.[1]?.should_not be_nil
      xs[0]?.not_nil!.t.should eq 5.0
      xs[1]?.not_nil!.t.should eq 5.0
    end
    it "ray misses a sphere" do
      r = Ray.new(Point.new(0, 2, -5), Vector.new(0, 0, 1))
      s = Sphere.new
      xs = s.intersect(r)
      xs.size.should eq 0
    end
    it "ray orginates inside a sphere" do
      r = Ray.new(Point.new(0, 0, 0), Vector.new(0, 0, 1))
      s = Sphere.new
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should_not be_nil
      xs.[1]?.should_not be_nil
      xs[0]?.not_nil!.t.should eq -1.0
      xs[1]?.not_nil!.t.should eq 1.0
    end
    it "sphere is behind a ray" do
      r = Ray.new(Point.new(0,0,5), Vector.new(0,0,1))
      s = Sphere.new
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should_not be_nil
      xs.[1]?.should_not be_nil
      xs[0]?.not_nil!.t.should eq -6.0
      xs[1]?.not_nil!.t.should eq -4.0
    end
    it "sets the object on the intersection" do
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      s = Sphere.new
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should_not be_nil
      xs.[0]?.not_nil!.object.should eq s
      xs.[1]?.should_not be_nil
      xs.[1]?.not_nil!.object.should eq s
    end
    it "inersects a scaled sphere with a ray" do
      r = Ray.new(Point.new(0,0,-5),Vector.new(0,0,1))
      s = Sphere.new
      s.transform = Transform.scale(2,2,2)
      xs = s.intersect(r)
      xs.size.should eq 2
      xs.[0]?.should_not be_nil
      xs.[0]?.not_nil!.t.should eq 3
      xs.[1]?.not_nil!.t.should eq 7
    end
    it "intersects a translated sphere with a ray" do
      r = Ray.new(Point.new(0,0,-5), Vector.new(0,0,1))
      s = Sphere.new
      s.transform = Transform.translate(5, 0, 0)
      xs = s.intersect(r)
      xs.size.should eq 0
    end
  end
  describe "#transform" do
    it "sphere default transformation" do
      s = Sphere.new
      s.transform.should eq Matrix.new_identity
    end
    it "changing a spheres transformation" do
      s = Sphere.new
      t = Transform.translate(2,3,4)
      s.transform = t
      s.transform.should eq t
    end
  end
  describe "#normal_at" do
    it "on a sphere at a point on the x axis" do
      s = Sphere.new
      n = s.normal_at(Point.new(1,0,0))
      n.should eq Vector.new(1,0,0)
    end
    it "on a sphere at a point on the y axis" do
      s = Sphere.new
      n = s.normal_at(Point.new(0,1,0))
      n.should eq Vector.new(0,1,0)
    end
    it "on a sphere at a point on the z axis" do
      s = Sphere.new
      n = s.normal_at(Point.new(0,0,1))
      n.should eq Vector.new(0,0,1)
    end
    it "on a sphere at a nonaxial point" do
      s = Sphere.new
      n = s.normal_at(Point.new(Math.sqrt(3)/3,Math.sqrt(3)/3,Math.sqrt(3)/3))
      n.should eq Vector.new(Math.sqrt(3)/3,Math.sqrt(3)/3,Math.sqrt(3)/3)
    end
    it "is a normalized vector" do
      s = Sphere.new
      n = s.normal_at(Point.new(Math.sqrt(3)/3,Math.sqrt(3)/3,Math.sqrt(3)/3))
      n.should eq n.normalize
    end
    it "computes the normal on a translated sphere" do
      s = Sphere.new
      s.transform = Transform.translate(0,1,0)
      n = s.normal_at(Point.new(0, 1.70711, -0.70711))
      n.should eq Vector.new(0, 0.7071067811865475,-0.7071067811865476)
    end
    it "computes the normal on a transformed sphere" do
      s = Sphere.new
      s.transform = Transform.scale(1,0.5,1) * Transform.rotate_z(Math::PI / 5)
      n = s.normal_at(Point.new(0, Math.sqrt(2)/2, (Math.sqrt(2)/2)*-1))
      n.should eq Vector.new(0, 0.9701425001453319, -0.24253562503633294)
    end
  end
  describe "#material" do
    it "has a default material" do
      s = Sphere.new
      m = s.material
      m.class.should eq Material
    end
    it "can be assigned a material" do
      s = Sphere.new
      m = Material.new
      m.ambient = 1
      s.material = m
      s.material.should eq m
    end
  end

  
end