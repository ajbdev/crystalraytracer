require "./spec_helper.cr"

describe Intersection do
  describe "#new" do
    it "encapsulates t and object" do
      s = Sphere.new()
      i = Intersection.new(3.5, s)
      i.t.should eq 3.5
      i.object.should eq s
    end  
  end
end