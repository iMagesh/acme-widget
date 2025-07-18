# Acme Widget Co Sales System Proof of Concept

## Overview

This Ruby project implements a shopping basket for Acme Widget Co, supporting:

- Product catalogue
- Delivery charge rules
- Special offers ("buy one red widget, get the second half price")

## Usage

1. Initialize the `Basket` with the product catalogue, delivery rules, and offers.
2. Use `add(product_code)` to add items.
3. Call `total` to get the final price (including delivery and offers).

## Example

```
basket = Basket.new(catalogue: CATALOGUE, delivery_rule: DELIVERY, offers: OFFERS)
basket.add("B01")
basket.add("G01")
puts basket.total # => "$37.85"
```

## Assumptions

- Product codes are unique and must exist in the catalogue.
- Delivery charge is based on the subtotal after offers are applied.
- The red widget offer applies to every pair of red widgets in the basket.
- Prices and delivery charges are hardcoded for this proof of concept.

- Retail rounding (truncate to two decimals) is used for all price calculations, matching real-world receipts.
- The basket only accepts valid product codes; invalid codes raise an error.
- Offers are applied before delivery charges.

## Test Cases

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

## Running

This is a standalone Ruby file. No external dependencies required.

To run the test suite:

```
ruby tests/basket.rb
```

Folder structure:

- `basket.rb` - Main basket logic
- `product_catalogue.rb` - Product catalogue
- `delivery_rule.rb` - Delivery charge rules
- `offers/` - Offer strategies
- `catalogue_data.rb` - Data setup
- `tests/basket.rb` - Test cases
