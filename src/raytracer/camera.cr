class Camera
  property h_size : Int32
  property v_size : Int32
  property fov : Float64
  property transform : Matrix
  getter pixel_size : Float32

  def initialize(h_size : Int32, v_size : Int32, fov : Float64)
    @h_size = h_size
    @v_size = v_size
    @fov = fov
    @transform = Matrix.new_identity
    @pixel_size = calc_pixel_size
  end

  def calc_pixel_size
    if aspect_ratio < 1
      half_width = half_view * aspect_ratio
      half_height = half_view
    else
      half_width = half_view
      half_height = half_view / aspect_ratio
    end

    (half_width * 2 / @h_size).to_f32
  end

  def half_view
    Math.tan(@fov / 2)
  end

  def aspect_ratio
    @h_size.to_f / @v_size.to_f
  end
end