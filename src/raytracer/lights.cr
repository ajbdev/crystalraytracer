module Lights
  class Point
    property position : ::Point
    property intensity : Color
    
    def initialize(position : ::Point, intensity : Color)
      @position = position
      @intensity = intensity
    end
  end
end