describe Lights do
  describe Point do
    describe "#new" do
      it "a point light has a position and intensity" do
        intensity = Color.new(1.0, 1.0, 1.0)
        position = Point.new(0, 0, 0)
        light = Lights::Point.new(position, intensity)
        
        light.position.should eq position
        light.intensity.should eq intensity
      end
    end
  end
end