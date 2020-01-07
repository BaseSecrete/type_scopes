# Type Scopes

Type scopes creates useful scopes based on the type of the columns of your models.
It handles dates, times, strings and numerics.

Here is an example of all the available scopes:

```ruby
# paid_at: datetime
# amount: decimal
# description: string
class Transaction < ActiveRecord::Base
  include TypeScopes
end

# Time scopes
Transaction.paid_to("2017-09-06") # => where("paid_at <= '2017-09-06'")
Transaction.paid_from("2017-09-06") # => where("paid_at >= '2017-09-06'")
Transaction.paid_after("2017-09-06") # => where("paid_at > '2017-09-06'")
Transaction.paid_before("2017-09-06") #= where("paid_at < '2017-09-06'")
Transaction.paid_between("2017-09-06", "2017-09-07")  # => where("paid_at BETWEEN '2017-09-06' AND '2017-09-07'")

# Numeric scopes
Transaction.amount_to(100) # => where("amount <= 100")
Transaction.amount_from(100) # => where("amount >= 100")
Transaction.amount_above(100) # => where("amount > 100")
Transaction.amount_below(100) # => where("amount < 100")
Transaction.amount_between(100, 200) # => where("amount BETWEEN 100 AND 200")

# String scopes
Transaction.description_contains("foo") # => where("description LIKE '%foo%'")
Transaction.description_starts_with("foo") # => where("description LIKE 'foo%'")
Transaction.description_ends_with("foo") # => where("description LIKE '%foo'")

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

For the string scope the pattern matching is escaped:

```ruby
Transaction.description_contains("%foo_") # => where("description LIKE '%[%]foo[_]%'")
```

## Install

Add to your Gemfile:

```ruby
gem "type_scopes"
```

And run in your terminal:

```shell
bundle install
```

Then include TypeScopes from your models:

```ruby
class Transaction < ActiveRecord::Base
  include TypeScopes
end
```

## MIT License

Made by [Base Secrète](https://basesecrete.com/en).

Rails developer? Check out [RoRvsWild](https://www.rorvswild.com), our Ruby on Rails application monitoring tool.
