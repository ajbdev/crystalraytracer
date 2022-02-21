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
    it "calculates the determinant of a 3x3 matrix" do
      a = Matrix.new([
        [ 1, 2, 6],
        [-5, 8,-4],
        [ 2, 6, 4]
      ])

      a.cofactor(0,0).should eq 56
      a.cofactor(0,1).should eq 12
      a.cofactor(0,2).should eq -46
      a.determinant.should eq -196
    end
    it "calculates the determinant of a 4x4 matrix" do
      a = Matrix.new([
        [-2,-8, 3, 5],
        [-3, 1, 7, 3],
        [ 1, 2,-9, 6],
        [-6, 7, 7,-9]
      ])

      a.cofactor(0,0).should eq 690
      a.cofactor(0,1).should eq 447
      a.cofactor(0,2).should eq 210
      a.cofactor(0,3).should eq 51
      a.determinant.should eq -4071
    end
    it "testing an invertible matrix for invertibility" do
      a = Matrix.new([
        [6, 4,4, 4],
        [5, 5,7, 6],
        [4,-9,3,-7],
        [9, 1,7,-6]
      ])
      
      a.determinant.should eq -2120
      a.invertible?.should eq true
    end
    it "testing a noninvertible matrix for invertibility" do
      a = Matrix.new([
        [-4, 2,-3,-3],
        [ 9, 6, 2, 6],
        [ 0,-5, 1,-5],
        [ 0, 0, 0, 0]
      ])
      a.determinant.should eq 0
      a.invertible?.should eq false
    end
    it "calculates the inverse of a matrix" do
      a = Matrix.new([
        [-5, 2, 6,-8],
        [ 1,-5, 1, 8],
        [ 7, 7,-6,-7],
        [ 1,-3, 7, 4]
      ])

      b = a.inverse
      a.determinant.should eq 532
      a.cofactor(2,3).should eq -160
      b[3][2].should eq -160/532
      a.cofactor(3,2).should eq 105
      b[2][3].should eq 105/532

      b.should eq Matrix.new([
        [0.21804511278195488,  0.45112781954887216, 0.24060150375939848, -0.045112781954887216], 
        [-0.8082706766917294,  -1.4567669172932332, -0.44360902255639095, 0.5206766917293233], 
        [-0.07894736842105263, -0.2236842105263158, -0.05263157894736842, 0.19736842105263158], 
        [-0.5225563909774437,  -0.8139097744360902, -0.3007518796992481,  0.30639097744360905]
      ])
      # b.should eq Matrix.new([
      #   [ 0.21805, 0.45113, 0.24060,-0.04511],
      #   [-0.80827,-1.45677,-0.44361, 0.52068],
      #   [-0.07895,-0.22368,-0.05263, 0.19737],
      #   [-0.52256,-0.81391,-0.30075, 0.30639]
      # ])
    end
    it "calculates a 2nd matrix inverse" do
      a = Matrix.new([
        [ 8,-5, 9, 2],
        [ 7, 5, 6, 1],
        [-6, 0, 9, 6],
        [-3, 0,-9,-4]
      ])

      #  | -0.15385 | -0.15385 | -0.28205 | -0.53846 | 
      #  | -0.07692 | 0.12308 | 0.02564 | 0.03077 | 
      #  | 0.35897 | 0.35897 | 0.43590 | 0.92308 |
      #  | -0.69231 | -0.69231 | -0.76923 | -1.92308 |

      a.inverse.should eq Matrix.new([
        [-0.15384615384615385, -0.15384615384615385,  -0.28205128205128205, -0.5384615384615384],
        [-0.07692307692307693,  0.12307692307692308,   0.02564102564102564,  0.03076923076923077],
        [ 0.358974358974359,    0.358974358974359,     0.4358974358974359,   0.9230769230769231],
        [-0.6923076923076923,  -0.6923076923076923,   -0.7692307692307693,  -1.9230769230769231]]
      )
    end
    it "calculates a 3rd matrix inverse" do
      a = Matrix.new([
        [ 9, 3, 0, 9],
        [-5,-2,-6,-3],
        [-4, 9, 6, 4],
        [-7, 6, 6, 2]
      ])

      # | -0.04074 | -0.07778 | 0.14444 | -0.22222 |
      # | -0.07778 | 0.03333 | 0.36667 | -0.33333 |
      # | -0.02901 | -0.14630 | -0.10926 | 0.12963 |
      # | 0.17778 | 0.06667 | -0.26667 | 0.33333 |

      a.inverse.should eq Matrix.new([
        [-0.040740740740740744, -0.07777777777777778, 0.14444444444444443, -0.2222222222222222], 
        [-0.07777777777777778,   0.03333333333333333, 0.36666666666666664, -0.3333333333333333], 
        [-0.029012345679012345, -0.14629629629629629, -0.10925925925925926, 0.12962962962962962], 
        [0.17777777777777778,    0.06666666666666667, -0.26666666666666666, 0.3333333333333333]
      ])
    end
    it "multiples a product by its inverse" do
      a = Matrix.new([
        [ 3,-9, 7, 3],
        [ 3,-8, 2,-9],
        [-4, 4, 4, 1],
        [-6, 5,-1, 1]
      ])
      b = Matrix.new([
        [ 8, 2, 2, 2],
        [ 3,-1, 7, 0],
        [ 7, 0, 5, 4],
        [ 6,-2, 0, 5]
      ])
      c = a * b

      (c * b.inverse).should eq(a)
    end
  end
end
