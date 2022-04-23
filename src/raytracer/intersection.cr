
class Intersection
  getter t
  getter object

  def initialize(t : Float64, obj : Shape)
    @t = t
    @object = obj
  end

  def precompute(r : Ray)
    point = r.position(@t)

    comps = Computations.new(
      t: @t,
      object: @object,
      point: point,
      eye_v: -r.direction,
      normal_v: @object.normal_at(point)
    )

    if comps.normal_v.dot(comps.eye_v) < 0
      comps.inside = true
      comps.normal_v = -comps.normal_v
    else
      comps.inside = false
    end

    comps.over_point = comps.calc_over_point

    comps
  end
end