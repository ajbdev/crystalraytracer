class Matrix
  getter rows : Int32
  getter columns : Int32
  getter matrix : Array(Array(Float64) | Array(Int32))

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @matrix = Array.new(rows) { Array.new(columns) { 0 }}
  end

  def initialize(matrix : Array(Array(Float64) | Array(Int32)))
    @rows = matrix.size
    @columns = matrix[0].size
    @matrix = matrix
  end

  def [](row : Int)
    @matrix[row]
  end
end