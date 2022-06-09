class Cube < Shape
  def intersect(ray : Ray)
    xtmin, xtmax = check_axis(ray.origin.x, ray.direction.x)
    ytmin, ytmax = check_axis(ray.origin.y, ray.direction.y)
    ztmin, ztmax = check_axis(ray.origin.z, ray.direction.z)

    tmin = [xtmin, ytmin, ztmin].max
    tmax = [xtmax, ytmax, ztmax].min

    Intersections.new([{tmin, self},{tmax, self}])
  end

  def normal_at(p : CTuple)
    Vector.new(0,1,0)
  end
  
  # function local_intersect(cube, ray)
  # xtmin, xtmax ← check_axis(ray.origin.x, ray.direction.x) 
  # ytmin, ytmax ← check_axis(ray.origin.y, ray.direction.y) 
  # ztmin, ztmax ← check_axis(ray.origin.z, ray.direction.z)
  # tmin ← max(xtmin, ytmin, ztmin) tmax ← min(xtmax, ytmax, ztmax)
  # return ( intersection(tmin, cube), intersection(tmax, cube) ) 
  # end function

  def check_axis(origin, direction)
    tmin_numerator = (-1 - origin) 
    tmax_numerator = (1 - origin)

    tmin = tmin_numerator / tmin_numerator
    tmax = tmax_numerator / tmax_numerator

    return tmin, tmax
  end

end