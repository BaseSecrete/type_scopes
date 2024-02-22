# Changelog of Type scopes

## 0.6.1 (2024-02-22)

- Check if table exists to prevent from ActiveRecord::StatementInvalid

## 0.6 (2021-10-15)

- Refactor by switching modules into classes.

  New usage is `TypeScopes.inject` instead of `include` :

  ```ruby
  class Model < ApplicationRecord
    TypeScopes.inject(self)
  end
  ```
