class Material
  property ambient : Float64
  property diffuse : Float64
  property specular : Float64
  property shininess : Float64
  property color : Color
  property reflective : Float64
  property pattern : Pattern?
  
  def initialize(ambient = 0.1, diffuse = 0.9, specular = 0.9, shininess = 200.0, color = Color.white, reflective = 0.0)
    @ambient = ambient
    @diffuse = diffuse
    @specular = specular
    @shininess = shininess
    @color = color
    @reflective = reflective
  end

  def color_at(point : CTuple)
    return @color unless (pattern = @pattern)
      
    pattern.pattern_at(point)
  end

  def lighting(light : Lights::Point, point : CTuple, eye_v : CTuple, normal_v : CTuple, in_shadow : Bool = false)
    effective_color = color_at(point) * light.intensity
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
    
    v = ambient
    v += diffuse + specular unless in_shadow

    Color.new(v.x, v.y, v.z)
  end
end