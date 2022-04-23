struct Computations
  property t : Float64
  property object : Shape
  property point : CTuple
  property eye_v : CTuple
  property normal_v : CTuple
  property inside : Bool?
  property over_point : CTuple

  def initialize(t : Float64, object : Shape, point : CTuple, eye_v : CTuple, normal_v : CTuple)
    @t = t
    @object = object
    @point = point
    @eye_v = eye_v
    @normal_v = normal_v
    @over_point = point + @normal_v * CTuple::EPSILON
  end
end