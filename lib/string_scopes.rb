module StringScopes
  def self.included(model)
    model.extend(ClassMethods)
    model.create_string_scopes
  end

  def self.escape(string)
    string = string.gsub("%".freeze, "[%]".freeze)
    string.gsub!("_".freeze, "[_]".freeze)
    string
  end

  module ClassMethods
    def create_string_scopes
      for column in columns
        if column.sql_type.index("character") == 0 || column.sql_type.index("text") == 0
          create_string_scopes_for_column(column.name)
        end
      end
    end

    def create_string_scopes_for_column(name)
      scope :"#{name}_contains", lambda { |str| where("#{quoted_table_name}.#{name} LIKE ?", "%#{StringScopes.escape(str)}%") }
      scope :"#{name}_starts_with", lambda { |str| where("#{quoted_table_name}.#{name} LIKE ?", "#{StringScopes.escape(str)}%") }
      scope :"#{name}_ends_with", lambda { |str| where("#{quoted_table_name}.#{name} LIKE ?", "%#{StringScopes.escape(str)}") }
    end
  end
end

# Type Scopes automatically create the relevant scopes for your columns' model.
# It handles column types: date time, numerics and strings.

# Example

# We have the following model Person: name, born_at, size

# Person.born_to(10.years.ago)
# Person.born_from(10.years.ago)
# Person.born_after(10.years.ago)
# Person.born_before(10.years.ago)
# Person.born_between(20.years.ago, 10.years.ago)

# Person.size_to(175)
# Person.size_from(175)
# Person.size_below(175)
# Person.size_above(175)
# Person.size_between(170, 189)

# Person.name_contains("Alexis")
# Person.name_stars_with("Al")
# Person.name_ends_with("is")
