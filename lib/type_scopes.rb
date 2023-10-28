class TypeScopes
  def self.inject(model, column_names = nil)
    column_names ||= model.table_exists? ? model.columns.map(&:name) : []
    for name in column_names
      if column = model.columns_hash[name]
        Time.support?(column.sql_type) && Time.inject_for_column(model, name)
        String.support?(column.sql_type) && String.inject_for_column(model, name)
        Numeric.support?(column.sql_type) && Numeric.inject_for_column(model, name)
        Boolean.support?(column.sql_type) && Boolean.inject_for_column(model, name)
      end
    end
  end

  def self.append_scope(model, name, block)
    model.scope(name, block) if !model.respond_to?(name, true)
  end

  def self.support?(column_type)
    types.any? { |type| column_type.include?(type) }
  end

  def self.types
    raise NotImplementedError
  end

  def self.inject_for_column(model, name)
    raise NotImplementedError
  end
end

require "type_scopes/time"
require "type_scopes/string"
require "type_scopes/numeric"
require "type_scopes/boolean"
