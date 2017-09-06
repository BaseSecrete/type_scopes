module TypeScopes
  def self.included(model)
    model.include(StringScopes)
    model.include(NumericScopes)
    model.include(TimestampScopes)
  end
end
