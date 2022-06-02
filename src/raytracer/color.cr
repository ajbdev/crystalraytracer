class Color < CTuple

  def initialize(tuple : Tuple)
    @tuple = tuple
  end

  def initialize(r : Float64, g : Float64, b : Float64, a : Float64 = 1.0)
    @tuple = {r,g,b,a}
  end

  def red
    @tuple[0]
  end

  def green
    @tuple[1]
  end

  def blue
    @tuple[2]
  end

  def alpha
    @tuple[3]
  end

  def rgba
    val
  end

  def to_rgb_int255
    s = self * 255

    { s.red.round_away.to_i.clamp(0,255), s.green.round_away.to_i.clamp(0,255), s.blue.round_away.to_i.clamp(0,255) }
  end

  def *(b : Color)
    hadamard_product(b)
  end

  def hadamard_product(b : Color)
    self.class.new(
      red * b.red,
      green * b.green,
      blue * b.blue
    )
  end

  def self.black
    new(0.0,0.0,0.0)
  end

  def self.white
    new(1.0,1.0,1.0)
  end

  def self.red
    new(1.0,0.0,0.0)
  end

  def self.green
    new(0.0,1.0,0.0)
  end

  def self.blue
    new(0.0,0.0,1.0)
  end
end