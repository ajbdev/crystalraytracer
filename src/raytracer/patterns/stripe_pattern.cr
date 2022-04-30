class StripePattern < Pattern
  property a : Color
  property b : Color
  property transform : Matrix

  def initialize(a : Color, b : Color, transform = Matrix.new(Matrix.identity))
    @a = a
    @b = b
    @transform = transform
  end

  def stripe_at(p : CTuple)
    return @a if p.x.floor % 2 == 0

    @b
  end

  def stripe_at_object(obj : Shape, world_point : Point)
    obj_point = obj.transform.inverse * world_point
    pattern_point = @transform.inverse * obj_point

    stripe_at(pattern_point)
  end

end