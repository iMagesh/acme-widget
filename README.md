# Acme Widget Co Sales System Proof of Concept

## Overview

This Ruby project implements a shopping basket for Acme Widget Co, supporting:

- Product catalogue
- Delivery charge rules
- Special offers ("buy one red widget, get the second half price")

# Prerequisites

- Ruby (>= 3.0 recommended)

## Usage

1. Initialize the `Basket` with the product catalogue, delivery rules, and offers.
2. Use `add(product_code)` to add items.
3. Call `total` to get the final price (including delivery and offers).

## Example

```ruby
basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
basket.add("B01")
basket.add("G01")
basket.add("R01")
puts basket.total # => "$68.80"
```

## System Details & Assumptions

- Product codes are unique and must exist in the catalogue.
- The basket tracks items by product code and only accepts valid codes (invalid codes raise an `UnknownProductCodeError`).
- Offers are applied before delivery charges, based on the subtotal after offers.
- Delivery charge rules are checked in order, using the first matching threshold.
- Retail rounding (truncate to two decimals) is used for all price calculations, matching real-world receipts and business rules.
- The red widget offer applies to every pair of red widgets in the basket.
- Prices and delivery charges are hardcoded for this proof of concept.
- No sales tax or VAT is applied; all prices are assumed to be final.
- Only the specified offer is implemented; other discounts or promotions are not supported.

## Sample Test Cases

| Products                | Expected Total |
| ----------------------- | -------------- |
| B01, G01                | $37.85         |
| R01, R01                | $54.37         |
| R01, G01                | $60.85         |
| B01, B01, R01, R01, R01 | $98.27         |

## How it works

- The basket tracks items by product code.
- Offers are applied before delivery charges.
- Delivery charge rules are checked in order, using the first matching threshold.

## Running Tests

To run the test suite and see pass/fail results:

```sh
ruby tests/basket.rb
```

You will see output for each test case, e.g.:

```
PASS:
 Scenario: Blue + Green, no offers, subtotal $37.85, delivery $4.95

 Products: B01, G01
 Results: => $37.85 (expected $37.85)
------------------------------------------------------------
```

## Folder structure:

Folder structure:

```
acme-widget/
|-- basket.rb                  # Main basket logic
|-- product_catalogue.rb       # Product catalogue
|-- delivery_rule.rb           # Delivery charge rules
|-- offers/
|   |-- base.rb                # Offer base class
|   |-- buy_one_get_one_half_price.rb  # Red widget offer logic
|   |-- all_offers.rb          # Offer loader/registry
|-- data/
|   |-- catalogue_data.rb      # Loads product and delivery data from YAML
|-- config/
|   |-- products.yml           # Product catalogue (edit to change products/prices)
|   |-- delivery_rules.yml     # Delivery rules (edit to change thresholds/charges)
|-- tests/
|   |-- basket.rb              # Test cases
```

- Prices and delivery charges are hardcoded for this proof of concept.

* Product and delivery data are now loaded from YAML files (`config/products.yml` and `config/delivery_rules.yml`).
  You can change products, prices, or delivery rules by editing these files.

### Offer System

The offer system uses a base class (`offers/base.rb`) that defines the interface for all offer strategies. To add a new offer:

1. Create a new class in the `offers/` folder, inheriting from `Base` and implementing the required methods.
2. Require or register your offer class in `offers/all.rb` so it is loaded by the system.
3. Register your offer instance in the `OFFERS` array in `data/catalogue_data.rb` so it is available to the basket.

For example, to add a new offer:

```ruby
# In offers/all_offers.rb (or offers/all.rb):
require_relative 'my_new_offer'

# In data/catalogue_data.rb:
OFFERS = [BuyOneGetOneHalfPrice.new("R01"), MyNewOffer.new("G01")]
```

The current implementation includes one offer: `buy_one_get_one_half_price.rb`, which applies a "buy one red widget, get the second half price" discount to every pair of red widgets in the basket.
