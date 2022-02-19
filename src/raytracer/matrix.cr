class Matrix
  getter rows : Int32
  getter columns : Int32
  getter matrix : Array(Array(Float64))

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @matrix = Array.new(rows) { Array.new(columns) { 0.0 }}
  end

  def initialize(matrix : Array(Array(Float64)))
    @rows = matrix.size
    @columns = matrix[0].size
    @matrix = matrix
  end

  def initialize(matrix : Array(Array(Float64 | Int32)))
    @rows = matrix.size
    @columns = matrix[0].size
    @matrix = Array.new(rows) { Array.new(columns) { 0.0 }}

    rows.times do |x|
      columns.times do |y|
        @matrix[x][y] = matrix[x][y].to_f
      end
    end
  end

  def *(other : Matrix)
    raise DimensionMismatch.new("Matrices must be square and of equal size") if @rows != other.columns
    
    result = Matrix.new(rows, columns)

    rows.times do |x|
      columns.times do |y|
        result[x][y] = (0..rows-1).map { |i| matrix[x][i] * other[i][y] }.sum
      end
    end

    result
  end

  def *(tuple : CTuple)
    raise DimensionMismatch.new("Tuple size must match column and row size") if tuple.size != columns != rows

    result = Array(Float64).new(rows)
    rows.times do |x|
      columns.times do |y|
        result[x] = (0..rows-1).map { |i| matrix[x][i] * tuple[i] }.sum
      end
    end

    CTuple.new(Tuple.from(result))
  end

  def ==(other : Matrix)
    matrix == other.matrix
  end

  def [](row : Int)
    matrix[row]
  end

  class DimensionMismatch < Exception

  end
end