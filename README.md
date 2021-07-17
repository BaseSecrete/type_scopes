# Type Scopes

Type scopes creates useful semantic scopes based on the type of the columns of your models.
It handles dates, times, strings, numerics and booleans.

Here are examples for all the available scopes:

```ruby
# paid_at: datetime
# amount: decimal
# description: string
class Transaction < ActiveRecord::Base
  TypeScopes.inject self
end

# Time scopes
Transaction.paid_to("2017-09-06") # => where("paid_at <= '2017-09-06'")
Transaction.paid_from("2017-09-06") # => where("paid_at >= '2017-09-06'")
Transaction.paid_after("2017-09-06") # => where("paid_at > '2017-09-06'")
Transaction.paid_before("2017-09-06") #= where("paid_at < '2017-09-06'")
Transaction.paid_between("2017-09-06", "2017-09-07")  # => where("paid_at BETWEEN '2017-09-06' AND '2017-09-07'")
Transaction.paid_not_between("2017-09-06", "2017-09-07")  # => where("paid_at NOT BETWEEN '2017-09-06' AND '2017-09-07'")
Transaction.paid_within("2017-09-06", "2017-09-07")  # => where("paid_at > '2017-09-06' AND paid_at < '2017-09-07'")
Transaction.paid_not_within("2017-09-06", "2017-09-07")  # => where("paid_at <= '2017-09-06' OR paid_at >= '2017-09-07'")

# Numeric scopes
Transaction.amount_to(100) # => where("amount <= 100")
Transaction.amount_from(100) # => where("amount >= 100")
Transaction.amount_above(100) # => where("amount > 100")
Transaction.amount_below(100) # => where("amount < 100")
Transaction.amount_between(100, 200) # => where("amount BETWEEN 100 AND 200")
Transaction.amount_not_between(100, 200) # => where("amount NOT BETWEEN 100 AND 200")
Transaction.amount_within(100, 200) # => where("amount > 100 AND amount < 200")
Transaction.amount_not_within(100, 200) # => where("amount <= 100 OR amount >= 200")

# String scopes
Transaction.description_contains("foo") # => where("description LIKE '%foo%'")
Transaction.description_contains("foo", sensitive: false) # => where("description ILIKE '%foo%'")
Transaction.description_starts_with("foo") # => where("description LIKE 'foo%'")
Transaction.description_starts_with("foo", sensitive: false) # => where("description ILIKE 'foo%'")
Transaction.description_does_not_start_with("foo") # => where("description NOT LIKE 'foo%'")
Transaction.description_does_not_start_with("foo", sensitive: false) # => where("description NOT ILIKE 'foo%'")
Transaction.description_ends_with("foo") # => where("description LIKE '%foo'")
Transaction.description_ends_with("foo", sensitive: false) # => where("description ILIKE '%foo'")
Transaction.description_does_not_end_with("foo") # => where("description NOT LIKE '%foo'")
Transaction.description_does_not_end_with("foo", sensitive: false) # => where("description NOT ILIKE '%foo'")
Transaction.description_like("%foo%") # => where("description LIKE '%foo%'")
Transaction.description_not_like("%foo%") # => where("description NOT LIKE '%foo%'")
Transaction.description_ilike("%foo%") # => where("description ILIKE '%foo%'")
Transaction.description_not_ilike("%foo%") # => where("description NOT ILIKE '%foo%'")
Transaction.description_matches("^Regex$") # => where("description ~ '^Regex$'")
Transaction.description_does_not_match("^Regex$") # => where("description !~ '^Regex$'")

# Boolean scopes
Transaction.non_profit # => where("non_profit = true")
Transaction.not_non_profit # => where("non_profit = false")
Transaction.is_valid # => where("is_valid = true")
Transaction.is_not_valid # => where("is_valid = false")
Transaction.has_payment # => where("has_payment = true")
Transaction.has_not_payment # => where("has_payment = false")
Transaction.was_processed # => where("was_processed = true")
Transaction.was_not_processed # => where("was_processed = false")
```

For the string colums, the pattern matching is escaped. So it's safe to provide directly a user input. There is an exception for the `column_like`, `column_ilike`, `column_matches` and `column_does_not_match` where the pattern is not escaped and you shouldn't provide untrusted strings.

```ruby
Transaction.description_contains("%foo_") # => where("description LIKE '%[%]foo[_]%'")
```

## Install

Add to your Gemfile `gem "type_scopes"` and run in your terminal `bundle install`. Then call `TypeScopes.inject` from your models:

```ruby
# /app/models/transaction.rb
class Transaction < ApplicationRecord
  # Creates scope for all supported column types
  TypeScopes.inject self

  # Or if you prefer to enable scopes for specific columns only
  TypeScopes.inject self, :amount, :paid_at
end
```

In case there is a conflict with a scope name, TypeScopes won't over write your existing scope. You can safely inject TypeScopes and it won't break any scope defined previously.

## MIT License

Made by [Base Secrète](https://basesecrete.com/en).

Rails developer? Check out [RoRvsWild](https://www.rorvswild.com), our Ruby on Rails application monitoring tool.
