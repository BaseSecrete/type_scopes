require File.expand_path("../../test_helper", __FILE__)

class TypeScopes::StringTest < TypeScopes::TestCase
  def setup
    TypeScopes::Transaction.connection.truncate(TypeScopes::Transaction.table_name)
    TypeScopes::Transaction.create!(amount: 100, paid_at: "2021-06-23", description: "First transaction")
    TypeScopes::Transaction.create!(amount: 200, paid_at: "2021-06-24", description: "Last transaction")
  end

  def test_contains
    assert_equal(2, TypeScopes::Transaction.description_contains("t t").count)
    assert_equal(0, TypeScopes::Transaction.description_contains("xxx").count)
  end

  def test_starts_with
    assert_equal(1, TypeScopes::Transaction.description_starts_with("First").count)
  end

  def test_ends_with
    assert_equal(2, TypeScopes::Transaction.description_ends_with("tion").count)
  end

  def test_escaped_characters
    assert_equal(0, TypeScopes::Transaction.description_contains("%").count)
    assert_equal(0, TypeScopes::Transaction.description_contains("_").count)
  end
end
