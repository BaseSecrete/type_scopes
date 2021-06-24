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

  def self.create_scopes_for_column(model, column)
    full_name = "#{model.quoted_table_name}.#{column}"
    append_scope(model, :"#{column}_contains", lambda { |str| where("#{full_name} LIKE ?", "%#{TypeScopes::String.escape(str)}%") })
    append_scope(model, :"#{column}_starts_with", lambda { |str| where("#{full_name} LIKE ?", "#{TypeScopes::String.escape(str)}%") })
    append_scope(model, :"#{column}_ends_with", lambda { |str| where("#{full_name} LIKE ?", "%#{TypeScopes::String.escape(str)}") })
  end
end
