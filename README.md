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
Transaction.paid_to("2017-09-06") # => where("paid_to <= '2017-09-06'")
Transaction.paid_from("2017-09-06") # => where("paid_to >= '2017-09-06'")
Transaction.paid_after("2017-09-06") # => where("paid_to > '2017-09-06'")
Transaction.paid_before("2017-09-06") #= where("paid_to < '2017-09-06'")
Transaction.paid_between("2017-09-06", "2017-09-07")  # => where("paid_to BETWEEN '2017-09-06' AND '2017-09-07'")

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
```

For the string scope the pattern matching is escaped:

```ruby
Transaction.description_contains("%foo_") # => where("description LIKE '%[%]foo[_]%'")
```

## MIT License

Made by [Base Secrète](https://basesecrete.com/en).

Rails developer? Check out [RoRvsWild](https://www.rorvswild.com), our Ruby on Rails application monitoring tool.
