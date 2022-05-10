require "../src/raytracer.cr"


floor = Sphere.new
floor.transform = Transform.scale(10, 0.01, 10)
floor.material = Material.new
floor.material.color = Color.new(1, 0.9, 0.9)
floor.material.specular = 0

left_wall = Sphere.new
left_wall.transform = Transform.translate(0,0,5)
                               .rotate_y(-Math::PI/4)
                               .rotate_x(Math::PI/2)
                               .scale(10, 0.01, 10)
left_wall.material = floor.material

right_wall = Sphere.new
right_wall.transform = Transform.translate(0,0,5)
                                .rotate_y(Math::PI/4)
                                .rotate_x(Math::PI/2)
                                .scale(10, 0.01, 10)

right_wall.material = floor.material

middle = Sphere.new
middle.transform = Transform.translate(-0.5, 1, 0.5)
middle.material = Material.new
middle.material.color = Color.new(0.1, 1, 0.5)
middle.material.diffuse = 0.7
middle.material.specular = 0.3

right = Sphere.new
right.transform = Transform.translate(1.5, 0.5, -0.5).scale(0.5, 0.5, 0.5)
right.material = Material.new
right.material.color = Color.new(0.5, 1, 0.1)
right.material.diffuse = 0.7
right.material.specular = 0.3

left = Sphere.new
left.transform = Transform.translate(-1.5, 0.33, -0.75).scale(0.33, 0.33, 0.33)
left.material = Material.new
left.material.color = Color.new(1, 0.8, 0.1)
left.material.diffuse = 0.7
left.material.specular = 0.3

world = World.new
world.light = Lights::Point.new(Point.new(-10, 10, -10), Color.new(1, 1, 1))

[floor, left_wall, right_wall, middle, right, left].each do |object|
  world.objects << object
end

camera = Camera.new(640, 480, Math::PI/3)
camera.transform = Transform.view_transform(Point.new(0, 1.5, -5),
                                             Point.new(0, 1, 0),
                                             Vector.new(0, 1, 0))

total_pixels = camera.v_size * camera.h_size
canvas = camera.render(world) do |pixels_rendered, x, y, color|
  str = "Rendered #{pixels_rendered}/#{total_pixels} pixels"
  print str
  str.size.times { print '\b' }
end

ppm_file = File.tempfile("crystalraytracer.ppm")

File.write(ppm_file.path, canvas.to_ppm)

puts "PPM generated at: #{ppm_file.path}"