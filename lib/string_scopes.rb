module StringScopes
  TYPES = ["character", "text"].freeze

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
        if TYPES.any? { |type| column.sql_type.include?(type) }
          create_string_scopes_for_column(column.name)
        end
      end
    end

    def create_string_scopes_for_column(name)
      full_name = "#{quoted_table_name}.#{name}"
      scope :"#{name}_contains", lambda { |str| where("#{full_name} LIKE ?", "%#{StringScopes.escape(str)}%") }
      scope :"#{name}_starts_with", lambda { |str| where("#{full_name} LIKE ?", "#{StringScopes.escape(str)}%") }
      scope :"#{name}_ends_with", lambda { |str| where("#{full_name} LIKE ?", "%#{StringScopes.escape(str)}") }
    end
  end
end
