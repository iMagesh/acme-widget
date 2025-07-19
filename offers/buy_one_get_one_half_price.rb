require 'bigdecimal'
require 'bigdecimal/util'

require_relative 'base_offer'

class BuyOneGetOneHalfPrice < BaseOffer
  def initialize(code)
    @code = code
  end

  def apply(item_counts, catalogue)
    count = item_counts[@code].to_i
    return 0.0 if count < 2

    price = catalogue.price(@code).to_d
    pairs = count / 2
    item_counts[@code] = count % 2

    subtotal = retail_round(pairs * price) + retail_round(pairs * (price / 2))
    subtotal
  end
end
