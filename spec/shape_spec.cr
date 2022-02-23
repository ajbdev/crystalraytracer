require "./spec_helper.cr"

describe Shape do
  describe Sphere do
    describe "#new" do
      it "ensures two spheres are not the same value" do
        a = Sphere.new
        b = Sphere.new
        
        a.should_not eq b
      end
    end
  end
end
