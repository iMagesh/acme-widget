# offers/base_offer.rb
class BaseOffer
  def apply(item_counts, catalogue)
    0.0 # Default: no discount
  end

  # Shared retail rounding utility
  def retail_round(amount)
    BigDecimal(amount.to_s).truncate(2)
  end
end
