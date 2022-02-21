require "./spec_helper.cr"

describe Matrix do
  describe "#new" do
    it "initializes with a 4x4 matrix" do
      m = Matrix.new([
        [ 1.0,  2.0,  3.0,  4.0],
        [ 5.5,  6.5,  7.5,  8.5],
        [ 9.0,  10.0, 11.0, 12.0 ],
        [ 13.5, 14.5, 15.5, 16.5]
      ])

      m[0][0].should eq 1
      m[0][3].should eq 4
      m[1][0].should eq 5.5
      m[1][2].should eq 7.5
      m[2][2].should eq 11
      m[3][0].should eq 13.5
      m[3][2].should eq 15.5
    end
    it "initializes with a 2x2 matrix" do
      m = Matrix.new([
        [-3.0, 5.0],
        [ 1.0,-2.0]
      ])

      m[0][0].should eq -3
      m[0][1].should eq 5
      m[1][0].should eq 1
      m[1][1].should eq -2
    end
    it "initializes with a 3x3 matrix" do
      m = Matrix.new([
        [ -3.0,  5.0,  0.0 ],
        [  1.0, -2.0, -7.0 ],
        [  0.0,  1.0,  1.0 ]
      ])

      m[0][0].should eq -3
      m[1][1].should eq -2
      m[2][2].should eq 1
    end
    it "casts integers to float64" do
      m = Matrix.new([
        [ -3,  5,  0 ],
        [  1, -2, -7 ],
        [  0,  1,  1 ]
      ])

      m[0][0].should eq -3
      m[1][1].should eq -2
      m[2][2].should eq 1
    end
  end
  describe "#equality" do
    it "recognizes matrices with the same values as equal" do
      a = Matrix.new([
        [1,2,3,4],
        [5,6,7,8],
        [9,8,7,6],
        [5,4,3,2]
      ])
      b = Matrix.new([
        [1,2,3,4],
        [5,6,7,8],
        [9,8,7,6],
        [5,4,3,2]
      ])

      a.should eq b
    end
    it "recognizes matrices with different values as inequal" do
      a = Matrix.new([
        [1,2,3,4],
        [5,6,7,8],
        [9,8,7,6],
        [5,4,3,2]
      ])
      b = Matrix.new([
        [2,3,4,5],
        [6,7,8,9],
        [8,7,6,5],
        [4,3,2,1]
      ])

      a.should_not eq b
    end
  end
  describe "#math" do
    it "multiplies matrices together properly" do
      a = Matrix.new([
        [1, 2, 3, 4],
        [5, 6, 7, 8],
        [9, 8, 7, 6],
        [5, 4, 3, 2]
      ])

      b = Matrix.new([
        [-2, 1, 2, 3],
        [ 3, 2, 1,-1],
        [ 4, 3, 6, 5],
        [ 1, 2, 7, 8]
      ])

      (a * b).should eq Matrix.new([
        [ 20, 22,  50,  48],
        [ 44, 54, 114, 108],
        [ 40, 58, 110, 102],
        [ 16, 26,  46,  42]
      ])
    end
    it "multiplies by a tuple" do
      a = Matrix.new([
        [1,2,3,4],
        [2,4,4,2],
        [8,6,4,1],
        [0,0,0,1]
      ])

      b = CTuple.new(1, 2, 3, 1)

      (a * b).val.should eq({ 18.0, 24.0, 33.0, 1.0 })
    end
    it "multiplies a matrix by the identity matrix" do
      a = Matrix.new([
        [0,1,2,4],
        [1,2,4,8],
        [2,4,8,16],
        [4,8,16,32]
      ])

      (a * a.identity).should eq(a)      
    end
  end
  describe "#transpose" do
    it "transposes a matrix" do
      a = Matrix.new([
        [0,9,3,0],
        [9,8,0,8],
        [1,8,5,3],
        [0,0,5,8]
      ])

      a.transpose.should eq Matrix.new([
        [0,9,1,0],
        [9,8,8,0],
        [3,0,5,5],
        [0,8,3,8]
      ])
    end
    it "transposing the identity matrix returns the identity matrix" do
      a = Matrix.new([
        [1,2,3,4],
        [2,4,4,2],
        [8,6,4,1],
        [0,0,0,1]
      ])

      a.identity.transpose.should eq a.identity
    end
  end
  describe "#submatrices" do
    it "calculates the determinants of a 2x2 matrix" do
      a = Matrix.new([
        [ 1,5],
        [-3,2]
      ])

      a.determinant.should eq 17
    end
    it "a submatrix of a 3x3 matrix is a 2x2 matrix" do
      a = Matrix.new([
        [ 1, 5, 0],
        [-3, 2, 7],
        [ 0, 6,-3]
      ])

      a.submatrix(0, 2).should eq Matrix.new([
        [-3, 2],
        [ 0, 6]
      ])
    end
    it "a submatrix of a 4x4 matrix is a 3x3 matrix" do
      a = Matrix.new([
        [-6, 1, 1, 6],
        [-8, 5, 8, 6],
        [-1, 0, 8, 2],
        [-7, 1,-1, 1]
      ])

      a.submatrix(2, 1).should eq Matrix.new([
        [-6, 1, 6],
        [-8, 8, 6],
        [-7,-1, 1]
      ])
    end
    it "calculates a minor of a 3x3 matrix" do
      a = Matrix.new([
        [3, 5, 0],
        [2,-1,-7],
        [6,-1, 5]
      ])
      b = a.submatrix(1, 0)

      b.determinant.should eq 25
      a.minor(1, 0).should eq 25
    end
    it "calculates a cofactor of a 3x3 matrix" do
      a = Matrix.new([
        [3, 5, 0],
        [2,-1,-7],
        [6,-1, 5]
      ])

      a.minor(0,0).should eq -12
      a.cofactor(0,0).should eq -12
      a.minor(1,0).should eq 25
      a.cofactor(1,0).should eq -25
    end
  end
end
