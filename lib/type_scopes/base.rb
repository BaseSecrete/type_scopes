module TypeScopes::Base
  def create_scopes_for_model(model)
    for column in model.columns
      if types.any? { |type| column.sql_type.include?(type) }
        create_scopes_for_column(model, column.name)
      end
    end
  end

  def append_scope(model, name, block)
    model.scope(name, block) if !model.respond_to?(name, true)
  end

  def included(model)
    create_scopes_for_model(model)
  end
end