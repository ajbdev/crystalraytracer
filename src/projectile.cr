require "./ctuple.cr"

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

p = Projectile.new(CTuple.new_point(0, 1, 0), CTuple.new_vector(1, 1, 0).normalize)
env = Environment.new(CTuple.new_vector(0, -0.1, 0), CTuple.new_vector(-0.01, 0, 0))

loop do
  p = tick(env, p)

  puts "Projectile x: #{p.position.x}, y: #{p.position.y}"

  break if p.position.y <= 0
end