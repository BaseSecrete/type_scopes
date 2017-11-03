require "string_scopes"
require "numeric_scopes"
require "timestamp_scopes"
require "boolean_scopes"

module TypeScopes
  def self.included(model)
    model.include(StringScopes)
    model.include(NumericScopes)
    model.include(TimestampScopes)
    model.include(BooleanScopes)
  end
end
