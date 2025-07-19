# Models delivery charge rules
class DeliveryRule
  def initialize(rules)
    @rules = rules.sort_by { |r| r[:threshold] }
  end

  def charge(subtotal)
    rule = @rules.find { |r| subtotal < r[:threshold] }
    rule ? rule[:charge] : 0.0
  end
end
