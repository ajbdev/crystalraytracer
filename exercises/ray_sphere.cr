require "../src/raytracer.cr"

ray_origin = Point.new(0,0,-5)

wall_z = 10

wall_size = 7.0

canvas_pixels = 100

pixel_size = wall_size / canvas_pixels

half = wall_size / 2

canvas = Canvas.new(canvas_pixels, canvas_pixels)
color = Color.new(1,0,0)
shape = Sphere.new

canvas_pixels.times do |y|
  world_y = half - pixel_size * y
  canvas_pixels.times do |x|
    world_x = (half*-1) + (pixel_size * x)
    position = Point.new(world_x, world_y, wall_z)
    
    r = Ray.new(ray_origin, (position - ray_origin).normalize)

    xs = shape.intersect(r)

    canvas.pixel(x, y, color) if xs.hit?
  end
end


ppm_file = File.tempfile("crystalraytracer.ppm")

File.write(ppm_file.path, canvas.to_ppm)

puts "PPM generated at: #{ppm_file.path}"