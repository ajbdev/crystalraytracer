class Material
  property ambient : Float64
  property diffuse : Float64
  property specular : Float64
  property shininess : Float64
  property color : Color
  
  def initialize
    @ambient = 0.1
    @diffuse = 0.9
    @specular = 0.9
    @shininess = 200.0
    @color = Color.white
  end

  def lighting(light : Lights::Point, point : CTuple, eye_v : CTuple, normal_v : CTuple)
    effective_color = @color * light.intensity
    light_v = (light.position - point).normalize

    ambient = effective_color * @ambient
    light_dot_normal = light_v.dot(normal_v)

    if light_dot_normal < 0
      diffuse = Color.black
      specular = Color.black
    else
      diffuse = effective_color * @diffuse * light_dot_normal

      reflect_v = -light_v.reflect(normal_v)
      reflect_dot_eye = reflect_v.dot(eye_v)

      specular = if reflect_dot_eye <= 0
        Color.black
      else
        factor = reflect_dot_eye ** @shininess
        light.intensity * @specular * factor
      end
    end
    
    v = ambient + diffuse + specular
    Color.new(v.x, v.y, v.z)
  end
end