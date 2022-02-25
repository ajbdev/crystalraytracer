require "../src/raytracer.cr"


canvas = Canvas.new(380, 380)

center = Point.new(190,190,0)

twelve_oclock = Point.new(0,1,0)

12.times do |hour|
  rotation = Transform.rotate_z(hour * Math::PI / 6)
  clock_hand = (rotation * twelve_oclock) * 180 + center
  
  x = clock_hand.x
  y = clock_hand.y

  canvas.pixel(x, y, Color.white)
  canvas.pixel(x+1,y, Color.white)
  canvas.pixel(x,y+1, Color.white)
  canvas.pixel(x+1,y+1, Color.white)
end

ppm_file = File.tempfile("crystalraytracer.ppm")

File.write(ppm_file.path, canvas.to_ppm)

puts "PPM generated at: #{ppm_file.path}"