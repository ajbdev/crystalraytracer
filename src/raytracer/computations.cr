struct Computations
  property t : Float64
  property object : Shape
  property point : CTuple
  property eye_v : CTuple
  property normal_v : CTuple
  property inside : Bool?
  property over_point : CTuple?
  property under_point : CTuple?
  property reflect_v : CTuple?
  property n1 : Float64?
  property n2 : Float64?

  def initialize(t : Float64, object : Shape, point : CTuple, eye_v : CTuple, normal_v : CTuple)
    @t = t
    @object = object
    @point = point
    @eye_v = eye_v
    @normal_v = normal_v
  end

  def calc_reflectance
    schlick
  end

  def schlick
    return 0.0 unless (n1 = @n1) && (n2 = @n2)

    # find the cosine of the angle between the eye and normal vectors
    cos = @eye_v.dot(@normal_v)

    # total internal reflection can only occur if n1 > n2
    if n1 > n2
      n = n1 / n2
      sin2_t = n**2 * (1.0 - cos**2)
      return 1.0 if sin2_t > 1.0

      cos = Math.sqrt(1.0 - sin2_t)
    end

    r0 = ((n1 - n2) / (n1 + n2))**2

    r0 + (1 - r0) * (1 - cos)**5
  end
end