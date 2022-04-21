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
    @pixel_size = 0
    @half_width = 0.0
    @half_height = 0.0

    calc_sizes
  end

  def calc_sizes
    if aspect_ratio < 1
      @half_width = half_view * aspect_ratio
      @half_height = half_view
    else
      @half_width = half_view
      @half_height = half_view / aspect_ratio
    end

    @pixel_size = (@half_width * 2 / @h_size).to_f32
  end

  def ray_for_pixel(px, py)
    x = (px.to_f32 + 0.5) * @pixel_size
    y = (py.to_f32 + 0.5) * @pixel_size

    world_x = @half_width - x
    world_y = @half_height - y

    pixel = @transform.inverse * Point.new(world_x, world_y, -1)
    origin = @transform.inverse * Point.new(0, 0, 0)
    direction = (pixel - origin).normalize

    Ray.new(origin, direction)
  end

  def half_view
    Math.tan(@fov / 2)
  end

  def aspect_ratio
    @h_size.to_f / @v_size.to_f
  end
end