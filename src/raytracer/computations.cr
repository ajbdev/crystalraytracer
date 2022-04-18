struct Computations
  property t : Float64
  property object : Shape
  property point : CTuple
  property eye_v : CTuple
  property normal_v : CTuple
  property inside : Bool?

  def initialize(t : Float64, object : Shape, point : CTuple, eye_v : CTuple, normal_v : CTuple)
    @t = t
    @object = object
    @point = point
    @eye_v = eye_v
    @normal_v = normal_v
  end
end