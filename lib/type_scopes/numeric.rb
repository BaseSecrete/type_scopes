module TypeScopes::Numeric
  TYPES = ["integer", "double precision", "numeric", "bigint", "decimal"].freeze

  def self.included(model)
    model.extend(ClassMethods)
    model.create_numeric_scopes
  end

  module ClassMethods
    def create_numeric_scopes
      for column in columns
        if TYPES.any? { |type| column.sql_type.include?(type) }
          create_numeric_scopes_for_column(column.name)
        end
      end
    end

    def create_numeric_scopes_for_column(name)
      full_name = "#{quoted_table_name}.#{name}"
      TypeScopes.append(self, :"#{name}_to", lambda { |value| where("#{full_name} <= ?", value) })
      TypeScopes.append(self, :"#{name}_from", lambda { |value| where("#{full_name} >= ?", value) })
      TypeScopes.append(self, :"#{name}_above", lambda { |value| where("#{full_name} > ?", value) })
      TypeScopes.append(self, :"#{name}_below", lambda { |value| where("#{full_name} < ?", value) })
      TypeScopes.append(self, :"#{name}_between", lambda { |from, to| where("#{full_name} BETWEEN ? AND ?", from, to) })
      TypeScopes.append(self, :"#{name}_not_between", lambda { |from, to| where("#{full_name} NOT BETWEEN ? AND ?", from, to) })
      TypeScopes.append(self, :"#{name}_within", lambda { |from, to| where("#{full_name} > ? AND #{full_name} < ?", from, to) })
      TypeScopes.append(self, :"#{name}_not_within", lambda { |from, to| where("#{full_name} <= ? OR #{full_name} >= ?", from, to) })
    end
  end
end
