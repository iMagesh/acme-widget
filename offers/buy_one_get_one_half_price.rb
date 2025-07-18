# offers/buy_one_get_one_half_price.rb
require_relative 'base_offer'

class BuyOneGetOneHalfPrice < Offer
  def initialize(code)
    @code = code
  end

  def apply(item_counts, catalogue)
    count = item_counts[@code] || 0
    offer_total = 0.0
    if count > 1
      pairs = count / 2
      remainder = count % 2
      offer_total += pairs * (catalogue.price(@code) + catalogue.price(@code) / 2)
      item_counts[@code] = remainder
    end
    offer_total
  end
end
