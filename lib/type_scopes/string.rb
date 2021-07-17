class TypeScopes::String < TypeScopes
  def self.types
    ["character", "text", "varchar"].freeze
  end

  def self.escape(string)
    string = string.gsub("%".freeze, "[%]".freeze)
    string.gsub!("_".freeze, "[_]".freeze)
    string
  end

  def self.inject_for_column(model, name)
    column = model.arel_table[name]
    append_scope(model, :"#{name}_like", lambda { |str, sensitive: true| where(column.matches(str, nil, sensitive)) })
    append_scope(model, :"#{name}_not_like", lambda { |str, sensitive: true| where(column.does_not_match(str, nil, sensitive)) })
    append_scope(model, :"#{name}_ilike", lambda { |str| where(column.matches(str)) })
    append_scope(model, :"#{name}_not_ilike", lambda { |str| where(column.does_not_match(str)) })

    append_scope(model, :"#{name}_contains", lambda { |str, sensitive: true|
      send("#{name}_like", "%#{TypeScopes::String.escape(str)}%", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_does_not_contain", lambda { |str, sensitive: true|
      send("#{name}_not_like", "%#{TypeScopes::String.escape(str)}%", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_does_not_contain", lambda { |str, sensitive: true|
      send("#{name}_like", "%#{TypeScopes::String.escape(str)}%", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_starts_with", lambda { |str, sensitive: true|
      send("#{name}_like", "#{TypeScopes::String.escape(str)}%", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_does_not_start_with", lambda { |str, sensitive: true|
      send("#{name}_not_like", "#{TypeScopes::String.escape(str)}%", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_ends_with", lambda { |str, sensitive: true|
      send("#{name}_like", "%#{TypeScopes::String.escape(str)}", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_does_not_end_with", lambda { |str, sensitive: true|
      send("#{name}_not_like", "%#{TypeScopes::String.escape(str)}", sensitive: sensitive)
    })

    append_scope(model, :"#{name}_matches", lambda { |str, sensitive: true| where(column.matches_regexp(str, sensitive)) })
    append_scope(model, :"#{name}_does_not_match", lambda { |str, sensitive: true| where(column.does_not_match_regexp(str, sensitive)) })
  end
end
