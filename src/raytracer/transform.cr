class Transform < Matrix
  def initialize(x, y, z)
    @matrix = Matrix.new(4, 4).identity.matrix
    @rows = 4
    @columns = 4
  end
end