class Color < CTuple
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
end