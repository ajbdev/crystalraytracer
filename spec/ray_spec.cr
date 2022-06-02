require "./spec_helper.cr"

describe Ray do
  describe "#new" do
    it "creates a ray with a point and a vector" do
      origin = Point.new(1, 2, 3)
      direction = Vector.new(4, 5, 6)
      r = Ray.new(origin, direction)
      r.origin.should eq origin
      r.direction.should eq direction
    end
  end
  describe "#position" do
    it "computes a point from a distance" do
      r = Ray.new(Point.new(2, 3, 4), Vector.new(1, 0, 0))
      r.position(0).should eq Point.new(2,3,4)
      r.position(1).should eq Point.new(3,3,4)
      r.position(-1).should eq Point.new(1, 3, 4)
      r.position(2.5).should eq Point.new(4.5, 3, 4)
    end
  end
  describe "#transform" do
    it "applies a translation" do
      r = Ray.new(Point.new(1,2,3), Vector.new(0,1,0))
      m = Transform.translate(3, 4, 5)
      r2 = r.transform(m)
      r2.origin.should eq Point.new(4,6,8)
      r2.direction.should eq Vector.new(0,1,0)
    end
    it "scales a ray" do
      r = Ray.new(Point.new(1,2,3), Vector.new(0,1,0))
      m = Transform.scale(2, 3, 4)
      r2 = r.transform(m)
      r2.origin.should eq Point.new(2,6,12)
      r2.direction.should eq Vector.new(0,3,0)
    end
  end

end