module TypeScopes::Time
  extend TypeScopes::Base

  def self.types
    ["timestamp", "datetime", "date"].freeze
  end

  def self.create_scopes_for_column(model, column)
    full_name = "#{model.quoted_table_name}.#{column}"
    short_name = shorten_column_name(column)
    append_scope(model, :"#{short_name}_to", lambda { |date| where("#{full_name} <= ?", date) })
    append_scope(model, :"#{short_name}_from", lambda { |date| where("#{full_name} >= ?", date) })
    append_scope(model, :"#{short_name}_after", lambda { |date| where("#{full_name} > ?", date) })
    append_scope(model, :"#{short_name}_before", lambda { |date| where("#{full_name} < ?", date) })
    append_scope(model, :"#{short_name}_between", lambda { |from, to| where("#{full_name} BETWEEN ? AND ?", from, to) })
    append_scope(model, :"#{short_name}_not_between", lambda { |from, to| where("#{full_name} NOT BETWEEN ? AND ?", from, to) })
    append_scope(model, :"#{short_name}_within", lambda { |from, to| where("#{full_name} > ? AND #{full_name} < ?", from, to) })
    append_scope(model, :"#{short_name}_not_within", lambda { |from, to| where("#{full_name} <= ? OR #{full_name} >= ?", from, to) })
  end

  def self.shorten_column_name(name)
    name.chomp("_at").chomp("_on")
  end
end
