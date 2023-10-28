# Changelog of Type scopes

## Unrealeased

- Check if table exists to prevent from ActiveRecord::StatementInvalid

## 0.6

- Refactor by switching modules into classes.

  New usage is `TypeScopes.inject` instead of `include` :

  ```ruby
  class Model < ApplicationRecord
    TypeScopes.inject(self)
  end
  ```
