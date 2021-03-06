require "./spec_helper.cr"

describe CTuple do
  describe "#new" do
    it "initializes with xyzw parameters" do
      CTuple.new(1.0, -2.0, 3.0, 1.0).val.should eq({1.0, -2.0, 3.0, 1.0 })  
    end
    it "initializes with a factory method for points" do
      point = CTuple.new_point(1.0,1.0,1.0)
      point.w.should eq 1.0
      point.point?.should eq true
    end
    it "initializes with a factory method for vectors" do
      vector = CTuple.new_vector(1.0,1.0,1.0) 
      vector.w.should eq 0.0
      vector.vector?.should eq true
    end
    it "initializes a vector as its own class" do
      vector = Vector.new(1.0,1.0,1.0)
      vector.vector?.should eq true
    end
    it "initializes a point as its own class" do
      point = Point.new(1.0,1.0,1.0)
      point.point?.should eq true
    end
  end

  describe "#math" do
    it "a point added to a vector creates a new point" do
      point = CTuple.new(3, -2, 5, 1)
      vector = CTuple.new(-2, 3, 1, 0)

      result = point + vector

      result.val.should eq({1.0, 1.0, 6.0, 1.0})
      result.point?.should eq true
    end

    it "subtracting two points creates a vector" do
      p1 = CTuple.new_point(3, 2, 1)
      p2 = CTuple.new_point(5, 6, 7)

      result = p1 - p2

      result.val.should eq({-2.0, -4.0, -6.0, 0.0})
      result.vector?.should eq true
    end

    it "subtracting a vector from a point creates a point" do
      point = CTuple.new_point(3,2,1)
      vector = CTuple.new_vector(5,6,7)

      result = point - vector
      result.val.should eq({-2.0,-4.0,-6.0,1.0})
      result.point?.should eq true
    end

    it "subtracting two vectors creates a vector" do
      v1 = CTuple.new_vector(3,2,1)
      v2 = CTuple.new_vector(5,6,7)

      result = v1 - v2
      result.val.should eq({-2.0,-4.0,-6.0,0.0})
      result.vector?.should eq true
    end

    it "negating a vector creates the opposite coordinates" do
      vector = CTuple.new_vector(1, -2, 3)
      
      vector.-.val.should eq({-1.0, 2.0, -3.0, 0.0})
    end

    it "multiplies a tuple by scalar" do
      tpl = CTuple.new(1,-2,3,-4)
      (tpl * 3.5).val.should eq({3.5, -7, 10.5, -14})
    end

    it "multiplies a tuple by fraction" do
      tpl = CTuple.new(1,-2,3,-4)
      (tpl * 0.5).val.should eq({0.5, -1, 1.5, -2})
    end

    it "divides a tuple by a scalar" do
      tpl = CTuple.new(1,-2,3,-4)
      (tpl / 2).val.should eq({0.5, -1, 1.5, -2})
    end

    it "computes the magnitude" do
      v1 = CTuple.new_vector(1, 0, 0)
      v1.magnitude.should eq(1)

      v2 = CTuple.new_vector(1, 2, 3)
      v2.magnitude.should eq(Math.sqrt(14))
    end

    it "vector normalizations" do
      CTuple.new_vector(4, 0, 0).normalize.val.should eq({1.0,0,0,0})
      CTuple.new_vector(1, 2, 3).normalize.val.should eq({1/Math.sqrt(14), 2/Math.sqrt(14), 3/Math.sqrt(14), 0.0})
    end

    it "magnitude of a normalized vector" do
      CTuple.new_vector(1, 2, 3).normalize.magnitude.should eq(1)
    end

    it "computes the dot product of two tuples" do
      CTuple.new_vector(1, 2, 3).dot(CTuple.new_vector(2, 3, 4)).should eq(20)
    end

    it "computes the cross product of two tuples" do
      a = CTuple.new_vector(1, 2, 3)
      b = CTuple.new_vector(2, 3, 4)
      a.cross(b).val.should eq({-1.0,2.0,-1.0,0.0})
      b.cross(a).val.should eq({1.0,-2.0,1.0,0.0})
    end
  end

  describe "#reflect" do
    it "reflects a vector approaching 45??" do
      v = Vector.new(1, -1, 0)
      n = Vector.new(0, 1, 0)
      r = v.reflect(n)

      r.should eq Vector.new(1, 1, 0)
    end

    it "reflects a vector off a slanted surface" do
      v = Vector.new(0, -1, 0)
      n = Vector.new(Math.sqrt(2)/2, Math.sqrt(2)/2, 0)
      r = v.reflect(n)

      r.should eq Vector.new(1, 0, 0)
    end
  end
  
end
