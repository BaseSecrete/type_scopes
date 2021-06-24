module TypeScopes::Boolean
  extend TypeScopes::Base

  def self.types
    ["bool", "boolean", "tinyint(1)"].freeze
  end

  def self.create_scopes_for_column(model, name)
    append_scope(model, :"#{name}", lambda { where(table_name => { name => true }) })

    prefix, suffix = /\A(has|is|was)_(.+)\z/.match(name).to_a[1..2]
    if prefix && suffix
      append_scope(model, :"#{prefix}_not_#{suffix}", lambda { where(table_name => { name => false }) })
    else
      append_scope(model, :"not_#{name}", lambda { where(table_name => { name => false }) })
    end
  end
end
