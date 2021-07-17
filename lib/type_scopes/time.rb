class TypeScopes::Time < TypeScopes::Base
  def self.types
    ["timestamp", "datetime", "date"].freeze
  end

  def self.create_scopes_for_column(model, name)
    short_name = shorten_column_name(name)
    column = model.arel_table[name]

    append_scope(model, :"#{short_name}_to", lambda { |date| where(column.lteq(date)) })
    append_scope(model, :"#{short_name}_from", lambda { |date| where(column.gteq(date)) })
    append_scope(model, :"#{short_name}_after", lambda { |date| where(column.gt(date)) })
    append_scope(model, :"#{short_name}_before", lambda { |date| where(column.lt(date)) })
    append_scope(model, :"#{short_name}_between", lambda { |from, to| where(name => from..to) })
    append_scope(model, :"#{short_name}_not_between", lambda { |from, to| where.not(name => from..to) })
    append_scope(model, :"#{short_name}_within", lambda { |from, to| where(column.gt(from)).where(column.lt(to)) })
    append_scope(model, :"#{short_name}_not_within", lambda { |from, to| where(column.lteq(from).or(column.gteq(to))) })
  end

  def self.shorten_column_name(name)
    name.chomp("_at").chomp("_on")
  end
end
