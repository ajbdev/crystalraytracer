
class Intersection
  getter t
  getter object

  def initialize(t : Float64, obj : Shape)
    @t = t
    @object = obj
  end

  # containers ← empty list
  # for i ← each intersection in xs 
  #   if i = hit then
  #     if containers is empty 
  #       comps.n1 ← 1.0
  #     else
  #       comps.n1 ← last(containers).material.refractive_index 
  #     end if
  #   end if
  #   if containers includes i.object then 
  #     remove i.object from containers
  #   else
  #     append i.object onto containers
  #   end if
  #   if i = hit then
  #     if containers is empty
  #       comps.n2 ← 1.0 else
  #       comps.n2 ← last(containers).material.refractive_index 
  #     end if
  #         terminate loop
  #   end if 
  # end for
  def compute_n(r : Ray, intersections : Intersections)
    objects = [] of Shape

    intersections.each do |intersection|
      obj = intersection.object
    end

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

    comps.reflect_v = r.direction.reflect(comps.normal_v)

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