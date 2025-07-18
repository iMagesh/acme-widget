# Models delivery charge rules
class DeliveryRule
  def initialize(rules)
    @rules = rules.sort_by { |r| r[:threshold] }
  end

  def charge(subtotal)
    rule = @rules.find { |r| subtotal < r[:threshold] }
    # puts "Delivery charge for subtotal $#{subtotal}: $#{rule ? rule[:charge] : 0.0}"
    rule ? rule[:charge] : 0.0
  end
end
