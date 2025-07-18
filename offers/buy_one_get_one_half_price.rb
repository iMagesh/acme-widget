require 'bigdecimal'
require 'bigdecimal/util'
# offers/buy_one_get_one_half_price.rb
require_relative 'base_offer'

class BuyOneGetOneHalfPrice < Offer
  def initialize(code)
    @code = code
  end

  def apply(item_counts, catalogue)
    count = item_counts[@code].to_i
    return 0.0 if count < 2

    price = catalogue.price(@code).to_d
    pairs = count / 2
    item_counts[@code] = count % 2

    # Calculate total for all pairs, truncating half price before multiplying
    subtotal = (pairs * price + pairs * (price / 2).truncate(2)).truncate(2)
    subtotal
  end
end
