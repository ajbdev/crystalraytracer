
class Intersection
  getter t
  getter object

  def initialize(t : Float64, obj : Shape)
    @t = t
    @object = obj
  end

  # if (intersections) {
  #     const objects = new Set

  #     for (const intersection of intersections) {
  #       const { object } = intersection

  #       if (intersection === this) {
  #         this.n1 = objects.size ? last(objects).material.refractive : 1.0
  #       }

  #       objects.has(object) ? objects.delete(object) : objects.add(object)

  #       if (intersection === this) {
  #         this.n2 = objects.size ? last(objects).material.refractive : 1.0
  #         break
  #       }
  #     }
  #   }

  def compute_n(comps : Computations, intersections : Intersections)
    objects = [] of Shape

    ix = 0
    while (ix < intersections.size)
      i = intersections[ix]

      if i == self
        comps.n1 = objects.empty? ? 1.0 : objects.last.material.refractive_index
      end

      if objects.includes?(i.object)
        objects.delete(i.object)
      else
        objects << i.object
      end

      if i == self
        comps.n2 = objects.empty? ? 1.0 : objects.last.material.refractive_index
        break
      end

      ix += 1
    end

    comps
  end

  def precompute(r : Ray, intersections : Intersections = Intersections.new)
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

    compute_n(comps, intersections)
  end
end