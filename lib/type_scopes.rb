module TypeScopes
  def self.for_columns(model, columns = model.columns.map(&:name))
    columns.each { |name| create_scopes_for_column(model, name.to_s) }
  end

  def self.create_scopes_for_column(model, name)
    if column = model.columns_hash[name]
      Time.support?(column.sql_type) && Time.create_scopes_for_column(model, name)
      String.support?(column.sql_type) && String.create_scopes_for_column(model, name)
      Numeric.support?(column.sql_type) && Numeric.create_scopes_for_column(model, name)
      Boolean.support?(column.sql_type) && Boolean.create_scopes_for_column(model, name)
    end
  end
end

require "type_scopes/base"
require "type_scopes/time"
require "type_scopes/string"
require "type_scopes/numeric"
require "type_scopes/boolean"
