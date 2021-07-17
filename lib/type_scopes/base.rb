class TypeScopes::Base
  def self.create_scopes_for_model(model)
    for column in model.columns
      if types.any? { |type| column.sql_type.include?(type) }
        create_scopes_for_column(model, column.name)
      end
    end
  end

  def self.append_scope(model, name, block)
    model.scope(name, block) if !model.respond_to?(name, true)
  end

  def self.support?(column_type)
    types.any? { |type| column_type.include?(type) }
  end

  def self.types
    raise NotImplementedError
  end

  def self.create_scopes_for_column(model, name)
    raise NotImplementedError
  end
end