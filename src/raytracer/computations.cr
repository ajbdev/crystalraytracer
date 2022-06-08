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
end