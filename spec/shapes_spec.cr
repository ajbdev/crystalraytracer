require "./spec_helper.cr"

describe Shapes do
  describe Shapes::Sphere do
    describe "#new" do
      it "ensures two spheres are not the same value" do
        a = Shapes::Sphere.new
        b = Shapes::Sphere.new
        
        a.should_not eq b
      end
    end
  end
end
