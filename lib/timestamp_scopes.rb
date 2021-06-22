module TimestampScopes
  TYPES = ["timestamp", "datetime", "date"].freeze

  def self.included(model)
    model.extend(ClassMethods)
    model.create_timestamp_scopes
  end

  module ClassMethods
    def create_timestamp_scopes
      for column in columns
        if TYPES.any? { |type| column.sql_type.include?(type) }
          create_timestamp_scopes_for_column(column.name)
        end
      end
    end

    def create_timestamp_scopes_for_column(name)
      full_name = "#{quoted_table_name}.#{name}"
      short_name = shorten_column_name(name)
      scope :"#{short_name}_to", lambda { |date| where("#{full_name} <= ?", date) }
      scope :"#{short_name}_from", lambda { |date| where("#{full_name} >= ?", date) }
      scope :"#{short_name}_after", lambda { |date| where("#{full_name} > ?", date) }
      scope :"#{short_name}_before", lambda { |date| where("#{full_name} < ?", date) }
      scope :"#{short_name}_between", lambda { |from, to| where("#{full_name} BETWEEN ? AND ?", from, to) }
      scope :"#{short_name}_not_between", lambda { |from, to| where("#{full_name} NOT BETWEEN ? AND ?", from, to) }
      scope :"#{short_name}_within", lambda { |from, to| where("#{full_name} > ? AND #{full_name} < ?", from, to) }
      scope :"#{short_name}_not_within", lambda { |from, to| where("#{full_name} <= ? OR #{full_name} >= ?", from, to) }
    end

    def shorten_column_name(name)
      name.chomp("_at").chomp("_on")
    end
  end
end
