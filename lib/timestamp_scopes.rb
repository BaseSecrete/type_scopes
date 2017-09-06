module TimestampScopes
  def self.included(model)
    model.extend(ClassMethods)
    model.create_timestamp_scopes
  end

  module ClassMethods
    def create_timestamp_scopes
      for column in columns
        if column.sql_type.index("timestamp") == 0
          create_timestamp_scopes_for_column(column.name)
        end
      end
    end

    def create_timestamp_scopes_for_column(name)
      short_name = shorten_column_name(name)
      scope :"#{short_name}_to", lambda { |date| where("#{quoted_table_name}.#{name} <= ?", date) }
      scope :"#{short_name}_from", lambda { |date| where("#{quoted_table_name}.#{name} >= ?", date) }
      scope :"#{short_name}_after", lambda { |date| where("#{quoted_table_name}.#{name} > ?", date) }
      scope :"#{short_name}_before", lambda { |date| where("#{quoted_table_name}.#{name} < ?", date) }
      scope :"#{short_name}_between", lambda { |from, to| where("#{quoted_table_name}.#{name} BETWEEN ? AND ?", from, to) }
    end

    def shorten_column_name(name)
      name.chomp("_at").chomp("_on")
    end
  end
end
