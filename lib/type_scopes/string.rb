module TypeScopes::String
  extend TypeScopes::Base

  def self.types
    ["character", "text", "varchar"].freeze
  end

  def self.escape(string)
    string = string.gsub("%".freeze, "[%]".freeze)
    string.gsub!("_".freeze, "[_]".freeze)
    string
  end

  def self.create_scopes_for_column(model, name)
    column = model.arel_table[name]
    append_scope(model, :"#{name}_contains", lambda { |str| where(column.matches("%" + TypeScopes::String.escape(str) + "%")) })
    append_scope(model, :"#{name}_starts_with", lambda { |str| where(column.matches(TypeScopes::String.escape(str) + "%")) })
    append_scope(model, :"#{name}_ends_with", lambda { |str| where(column.matches("%" + TypeScopes::String.escape(str))) })
  end
end
