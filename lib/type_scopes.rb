module TypeScopes
  def self.included(model)
    model.include(TypeScopes::Time)
    model.include(TypeScopes::String)
    model.include(TypeScopes::Numeric)
    model.include(TypeScopes::Boolean)
  end
end

require "type_scopes/base"
require "type_scopes/time"
require "type_scopes/string"
require "type_scopes/numeric"
require "type_scopes/boolean"
