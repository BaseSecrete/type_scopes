require "string_scopes"
require "numeric_scopes"
require "timestamp_scopes"

module TypeScopes
  def self.included(model)
    model.include(StringScopes)
    model.include(NumericScopes)
    model.include(TimestampScopes)
  end
end
