describe Material do
  describe "#new" do
    it "has a default material" do
      m = Material.new

      m.ambient.should eq 0.1
      m.diffuse.should eq 0.9
      m.specular.should eq 0.9
      m.shininess.should eq 200.0
    end
  end

  before_each_it = -> {
    { Material.new, Point.new(0,0,0) }
  }
  
  describe "#lighting" do

    it "lighting with the eye between the light and the surface" do
      m, position = before_each_it.call

      eye_v = Vector.new(0, 0, -1)
      normal_v = Vector.new(0, 0, -1)
      light = Lights::Point.new(Point.new(0, 0, -10), Color.new(1, 1, 1))
      result = m.lighting(light, position, eye_v, normal_v)

      result.should eq Color.new(1.9, 1.9, 1.9)
    end

    it "lighting with the eye between light and surface, eye offset 45°" do
      m, position = before_each_it.call

      eye_v = Vector.new(0, Math.sqrt(2)/2, Math.sqrt(2)/2)
      normal_v = Vector.new(0, 0, -1)
      light = Lights::Point.new(Point.new(0,0,-10), Color.new(1, 1, 1))
      result = m.lighting(light, position, eye_v, normal_v)

      result.should eq Color.new(1.0, 1.0, 1.0)
    end

    it "lighting with eye opposite surface, light offset 45°" do
      m, position = before_each_it.call

      eye_v = Vector.new(0, 0, -1)
      normal_v = Vector.new(0, 0, -1)
      light = Lights::Point.new(Point.new(0, 10, -10), Color.new(1, 1, 1))

      result = m.lighting(light, position, eye_v, normal_v)
      result.should eq Color.new(0.7363961030678927, 0.7363961030678927, 0.7363961030678927)
    end

    it "lighting with eye in the path of the reflection vector" do
      m, position = before_each_it.call

      eye_v = Vector.new(0, -(Math.sqrt(2)/2), -(Math.sqrt(2)/2))
      normal_v = Vector.new(0, 0, -1)
      light = Lights::Point.new(Point.new(0, 10, -10), Color.new(1, 1, 1))
      
      result = m.lighting(light, position, eye_v, normal_v)
      result.should eq Color.new(1.6363930225043783,1.6363930225043783,1.6363930225043783)
    end

    it "lighting with the light behind the surface" do
      m, position = before_each_it.call

      eye_v = Vector.new(0, 0, -1)
      normal_v = Vector.new(0, 0, -1)
      light = Lights::Point.new(Point.new(0, 0, 10), Color.new(1, 1, 1))

      result = m.lighting(light, position, eye_v, normal_v)
      result.should eq Color.new(0.1, 0.1, 0.1)
    end
  end

  describe "shadows" do
    it "lighting with the surface in shadow" do
      m, position = before_each_it.call

      eye_v = Vector.new(0, 0, -1)
      normal_v = Vector.new(0, 0, -1)
      light = Lights::Point.new(Point.new(0,0,-10),Color.new(1,1,1))
      in_shadow = true
      result = m.lighting(light, position, eye_v, normal_v, in_shadow)
      result.should eq Color.new(0.1,0.1,0.1)
    end
  end

  describe "patterns" do
    it "displays a striped pattern" do
      m, position = before_each_it.call

      m.pattern = StripePattern.new(Color.new(1,1,1),Color.new(0,0,0))
      m.ambient = 1
      m.diffuse = 0
      m.specular = 0
      eye_v = Vector.new(0,0,-1)
      normal_v = Vector.new(0,0,-1)
      light = Lights::Point.new(Point.new(0,0,-10),Color.new(1,1,1))
      c1 = m.lighting(light, Point.new(0.9,0,0), eye_v, normal_v, false)
      c2 = m.lighting(light, Point.new(1.1,0,0), eye_v, normal_v, false)

      c1.should eq Color.new(1,1,1)
      c2.should eq Color.new(0,0,0)
    end
  end
end