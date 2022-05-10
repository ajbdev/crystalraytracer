abstract class Pattern
  property transform : Matrix

  def initialize(transform = Matrix.new(Matrix.identity))
    @transform = transform
  end

  abstract def pattern_at(p : CTuple) : Color

  def pattern_at_object(obj : Shape, world_point : Point) : Color
    obj_point = obj.transform.inverse * world_point
    pattern_point = @transform.inverse * obj_point

    pattern_at(pattern_point)    
  end
end
