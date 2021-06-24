require File.expand_path("../../test_helper", __FILE__)

class TypeScopes::BooleanTest < TypeScopes::TestCase
  def setup
    TypeScopes::Transaction.connection.truncate(TypeScopes::Transaction.table_name)
    TypeScopes::Transaction.create!(amount: 100, paid_at: "2021-06-23", description: "First transaction")
    TypeScopes::Transaction.create!(amount: 200, paid_at: "2021-06-24", description: "Last transaction")
  end

  def test_without_prefix
    assert_equal(0, TypeScopes::Transaction.non_profit.count)
    assert_equal(2, TypeScopes::Transaction.not_non_profit.count)
  end

  def test_has
    assert_equal(0, TypeScopes::Transaction.has_payment.count)
    assert_equal(2, TypeScopes::Transaction.has_not_payment.count)
  end

  def test_is
    assert_equal(0, TypeScopes::Transaction.is_valid.count)
    assert_equal(2, TypeScopes::Transaction.is_not_valid.count)
  end

  def test_was
    assert_equal(0, TypeScopes::Transaction.was_processed.count)
    assert_equal(2, TypeScopes::Transaction.was_not_processed.count)
  end
end
