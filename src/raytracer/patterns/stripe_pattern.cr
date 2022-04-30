class StripePattern < Pattern
  property a
  property b

  def initialize(a : Color, b : Color)
    @a = a
    @b = b
  end

  def stripe_at(p : CTuple)
    return @a if p.x.floor % 2 == 0

    @b
  end
end