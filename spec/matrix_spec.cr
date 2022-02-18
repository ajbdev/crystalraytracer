require "./spec_helper.cr"

describe Matrix do
  describe "#new" do
    it "initializes with a 4x4 matrix" do
      m = Matrix.new([
        [ 1,    2,    3,    4],
        [ 5.5,  6.5,  7.5,  8.5],
        [ 9,    10,   11,   12 ],
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
  end
end
