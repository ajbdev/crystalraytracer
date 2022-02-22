require "./raytracer.cr"


canvas = Canvas.new(380, 380)

origin = Point.new(0,0,0)

center = Point.new(190,190,0)

mid = center + origin

canvas.pixel(mid.x, mid.y, Color.white)


ppm_file = File.tempfile("crystalraytracer.ppm")

File.write(ppm_file.path, canvas.to_ppm)
puts "PPM generated at: #{ppm_file.path}"