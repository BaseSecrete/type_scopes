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
