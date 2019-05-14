module NumericScopes
  TYPES = ["integer", "double precision", "numeric", "bigint"].freeze

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
      scope :"#{name}_to", lambda { |value| where("#{quoted_table_name}.#{name} <= ?", value) }
      scope :"#{name}_from", lambda { |value| where("#{quoted_table_name}.#{name} >= ?", value) }
      scope :"#{name}_above", lambda { |value| where("#{quoted_table_name}.#{name} > ?", value) }
      scope :"#{name}_below", lambda { |value| where("#{quoted_table_name}.#{name} < ?", value) }
      scope :"#{name}_between", lambda { |from, to| where("#{quoted_table_name}.#{name} BETWEEN ? AND ?", from, to) }
    end
  end
end
