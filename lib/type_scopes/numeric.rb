class TypeScopes::Numeric < TypeScopes::Base
  def self.types
    ["integer", "double precision", "numeric", "bigint", "decimal"].freeze
  end

  def self.create_scopes_for_column(model, name)
    column = model.arel_table[name]
    append_scope(model, :"#{name}_to", lambda { |value| where(column.lteq(value)) })
    append_scope(model, :"#{name}_from", lambda { |value| where(column.gteq(value)) })
    append_scope(model, :"#{name}_above", lambda { |value| where(column.gt(value)) })
    append_scope(model, :"#{name}_below", lambda { |value| where(column.lt(value)) })
    append_scope(model, :"#{name}_between", lambda { |from, to| where(name => from..to) })
    append_scope(model, :"#{name}_not_between", lambda { |from, to| where.not(name => from..to) })
    append_scope(model, :"#{name}_within", lambda { |from, to| where(column.gt(from)).where(column.lt(to)) })
    append_scope(model, :"#{name}_not_within", lambda { |from, to| where(column.lteq(from).or(column.gteq(to))) })
  end
end
