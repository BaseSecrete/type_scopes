require File.expand_path("../../test_helper", __FILE__)

class TypeScopes::NumericTest < TypeScopes::TestCase
  def setup
    TypeScopes::Transaction.connection.truncate(TypeScopes::Transaction.table_name)
    TypeScopes::Transaction.create!(amount: 100)
    TypeScopes::Transaction.create!(amount: 200)
  end

  def test_to
    assert_equal(1, TypeScopes::Transaction.amount_to(199.99).count)
    assert_equal(2, TypeScopes::Transaction.amount_to(200).count)
  end

  def test_from
    assert_equal(2, TypeScopes::Transaction.amount_from(100).count)
    assert_equal(1, TypeScopes::Transaction.amount_from(100.01).count)
  end

  def test_above
    assert_equal(2, TypeScopes::Transaction.amount_above(99.99).count)
    assert_equal(1, TypeScopes::Transaction.amount_above(100).count)
  end

  def test_below
    assert_equal(1, TypeScopes::Transaction.amount_below(200).count)
    assert_equal(2, TypeScopes::Transaction.amount_below(200.01).count)
  end

  def test_between
    assert_equal(2, TypeScopes::Transaction.amount_between(100, 200).count)
    assert_equal(0, TypeScopes::Transaction.amount_between(100.01, 199.99).count)
  end

  def test_not_between
    assert_equal(0, TypeScopes::Transaction.amount_not_between(100, 200).count)
    assert_equal(2, TypeScopes::Transaction.amount_not_between(100.01, 199.99).count)
  end

  def test_within
    assert_equal(0, TypeScopes::Transaction.amount_within(100, 200).count)
    assert_equal(2, TypeScopes::Transaction.amount_within(99.99, 200.01).count)
  end

  def test_not_within
    assert_equal(2, TypeScopes::Transaction.amount_not_within(100, 200).count)
    assert_equal(0, TypeScopes::Transaction.amount_not_within(99.99, 200.01).count)
  end
end
