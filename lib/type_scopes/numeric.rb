module TypeScopes::Numeric
  extend TypeScopes::Base

  def self.types
    ["integer", "double precision", "numeric", "bigint", "decimal"].freeze
  end

  def self.create_scopes_for_column(model, column)
    full_name = "#{model.quoted_table_name}.#{column}"
    append_scope(model, :"#{column}_to", lambda { |value| where("#{full_name} <= ?", value) })
    append_scope(model, :"#{column}_from", lambda { |value| where("#{full_name} >= ?", value) })
    append_scope(model, :"#{column}_above", lambda { |value| where("#{full_name} > ?", value) })
    append_scope(model, :"#{column}_below", lambda { |value| where("#{full_name} < ?", value) })
    append_scope(model, :"#{column}_between", lambda { |from, to| where("#{full_name} BETWEEN ? AND ?", from, to) })
    append_scope(model, :"#{column}_not_between", lambda { |from, to| where("#{full_name} NOT BETWEEN ? AND ?", from, to) })
    append_scope(model, :"#{column}_within", lambda { |from, to| where("#{full_name} > ? AND #{full_name} < ?", from, to) })
    append_scope(model, :"#{column}_not_within", lambda { |from, to| where("#{full_name} <= ? OR #{full_name} >= ?", from, to) })
  end
end
