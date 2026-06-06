class TypeScopes::Numeric < TypeScopes
  def self.types
    ["integer", "double precision", "numeric", "bigint", "decimal"].freeze
  end

  def self.inject_for_column(model, name)
    column = model.arel_table[name]
    append_scope(model, :"#{name}_to", lambda { |value| where(column.lteq(value)) })
    append_scope(model, :"#{name}_from", lambda { |value| where(column.gteq(value)) })
    append_scope(model, :"#{name}_above", lambda { |value| where(column.gt(value)) })
    append_scope(model, :"#{name}_below", lambda { |value| where(column.lt(value)) })
    append_scope(model, :"#{name}_between", lambda { |*args| where(name => TypeScopes.args_to_range(*args)) })
    append_scope(model, :"#{name}_not_between", lambda { |*args| where.not(name => TypeScopes.args_to_range(*args)) })
    append_scope(model, :"#{name}_within", lambda { |from, to| where(column.gt(from)).where(column.lt(to)) })
    append_scope(model, :"#{name}_not_within", lambda { |from, to| where(column.lteq(from).or(column.gteq(to))) })
  end
end
