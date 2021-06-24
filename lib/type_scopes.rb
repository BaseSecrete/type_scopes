module TypeScopes
  def self.included(model)
    model.include(TypeScopes::Time)
    model.include(TypeScopes::String)
    model.include(TypeScopes::Numeric)
    model.include(TypeScopes::Boolean)
  end

  def self.append(model, name, block)
    model.scope(name, block) if !model.respond_to?(name, true)
  end
end

require "type_scopes/time"
require "type_scopes/string"
require "type_scopes/numeric"
require "type_scopes/boolean"
