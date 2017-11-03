module BooleanScopes
  TYPES = ["bool", "boolean", "tinyint(1)"].freeze

  def self.included(model)
    model.extend(ClassMethods)
    model.create_boolean_scopes
  end

  module ClassMethods
    def create_boolean_scopes
      for column in columns
        if TYPES.include?(column.sql_type)
          create_boolean_scopes_for_column(column.name)
        end
      end
    end

    def create_boolean_scopes_for_column(name)
      scope :"#{name}?", lambda { |value| where(quoted_table_name => { name => true }) }

      prefix, suffix = /\A(has|is|was)_(.+)\z/.match(name).to_a[1..2]
      if prefix && suffix
        scope :"#{prefix}_not_#{suffix}?", lambda { |value| where(quoted_table_name => { name => false }) }
      else
        scope :"not_#{name}?", lambda { |value| where(quoted_table_name => { name => false }) }
      end
    end
  end
end
