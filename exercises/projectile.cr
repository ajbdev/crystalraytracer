require "../src/raytracer.cr"

struct Environment
  property gravity : CTuple
  property wind : CTuple

  def initialize(gravity, wind)
    @gravity = gravity
    @wind = wind
  end
end

struct Projectile
  property position : CTuple
  property velocity : CTuple

  def initialize(position, velocity)
    @position = position
    @velocity = velocity
  end
end

def tick(env : Environment, p : Projectile)
  position = p.position + p.velocity
  velocity = p.velocity + env.gravity + env.wind
  return Projectile.new(position, velocity)
end

# start ← point(0, 1, 0)
# velocity ← normalize(vector(1, 1.8, 0)) * 11.25 p ← projectile(start, velocity)
# gravity ← vector(0, -0.1, 0) wind ← vector(-0.01, 0, 0)
# e ← environment(gravity, wind)
# c ← canvas(900, 550)

p = Projectile.new(CTuple.new_point(0, 1, 0), CTuple.new_vector(1, 1.8, 0).normalize * 11.25)
env = Environment.new(CTuple.new_vector(0, -0.1, 0), CTuple.new_vector(-0.01, 0, 0))
canvas = Canvas.new(900, 550)

loop do
  p = tick(env, p)

  x = p.position.x.round_away.to_i
  y = p.position.y.round_away.to_i

  canvas.pixel(x, y, Color.new(1,1,1))

  puts "Projectile x: #{x}, y: #{y}"

  break if p.position.y <= 0
end

ppm_file = File.tempfile("crystalraytracer.ppm")

File.write(ppm_file.path, canvas.to_ppm)

puts "PPM generated at: #{ppm_file.path}"