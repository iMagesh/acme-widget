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
puts basket.total # => "$75.75"
```

## System Details & Assumptions

- Product codes are unique and must exist in the catalogue.
- The basket tracks items by product code and only accepts valid codes (invalid codes raise an error).
- Offers are applied before delivery charges, based on the subtotal after offers.
- Delivery charge rules are checked in order, using the first matching threshold.
- Retail rounding (truncate to two decimals) is used for all price calculations, matching real-world receipts.
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
PASS: B01, G01 => $37.85 (expected $37.85)
  Scenario: Blue + Green, no offers, subtotal $37.85, delivery $0.00
------------------------------------------------------------
```

## Folder structure:

```text
basket.rb                  # Main basket logic
product_catalogue.rb       # Product catalogue
delivery_rule.rb           # Delivery charge rules
offers/                    # Offer strategies
  base.rb                  # Offer base class
  buy_one_get_one_half_price.rb  # Red widget offer logic
  all_offers.rb            # Offer loader/registry
catalogue_data.rb          # Data setup (can be replaced with a database, YAML, or JSON in a real system)
tests/basket.rb            # Test cases
```

### Offer System

The offer system uses a base class (`offers/base.rb`) that defines the interface for all offer strategies. To add a new offer:

1. Create a new class in the `offers/` folder, inheriting from `Base` and implementing the required methods.
2. Register your offer in `all_offers.rb` so it is available to the basket.

The current implementation includes one offer: `buy_one_get_one_half_price.rb`, which applies a "buy one red widget, get the second half price" discount to every pair of red widgets in the basket.
