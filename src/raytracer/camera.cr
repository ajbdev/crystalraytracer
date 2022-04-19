class Camera
  property h_size : Int32
  property v_size : Int32
  property fov : Float64
  property transform : Matrix

  def initialize(h_size : Int32, v_size : Int32, fov : Float64)
    @h_size = h_size
    @v_size = v_size
    @fov = fov
    @transform = Matrix.new_identity
  end
end