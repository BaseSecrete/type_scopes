require File.expand_path("../../test_helper", __FILE__)

class TypeScopes::TimeTest < TypeScopes::TestCase
  def setup
    TypeScopes::Transaction.connection.truncate(TypeScopes::Transaction.table_name)
    TypeScopes::Transaction.create!(amount: 100, paid_at: "2021-06-23")
    TypeScopes::Transaction.create!(amount: 200, paid_at: "2021-06-24")
  end

  def test_to
    assert_equal(1, TypeScopes::Transaction.paid_to("2021-06-23T23:59:59").count)
    assert_equal(2, TypeScopes::Transaction.paid_to("2021-06-24T00:00:00").count)
  end

  def test_from
    assert_equal(2, TypeScopes::Transaction.paid_from("2021-06-23").count)
    assert_equal(1, TypeScopes::Transaction.paid_from("2021-06-23T00:00:01").count)
  end

  def test_above
    assert_equal(2, TypeScopes::Transaction.paid_after("2021-06-22T23:59:59").count)
    assert_equal(1, TypeScopes::Transaction.paid_after("2021-06-23T00:00:00").count)
  end

  def test_below
    assert_equal(1, TypeScopes::Transaction.paid_before("2021-06-24").count)
    assert_equal(2, TypeScopes::Transaction.paid_before("2021-06-24T00:00:01").count)
  end

  def test_between
    assert_equal(2, TypeScopes::Transaction.paid_between("2021-06-23", "2021-06-24T00:00:00").count)
    assert_equal(0, TypeScopes::Transaction.paid_between("2021-06-23T00:00:01", "2021-06-23T23:59:59").count)
  end

  def test_not_between
    assert_equal(0, TypeScopes::Transaction.paid_not_between("2021-06-23", "2021-06-24T00:00:00").count)
    assert_equal(2, TypeScopes::Transaction.paid_not_between("2021-06-23T00:00:01", "2021-06-23T23:59:59").count)
  end

  def test_within
    assert_equal(0, TypeScopes::Transaction.paid_within("2021-06-23T00:00:00", "2021-06-24").count)
    assert_equal(2, TypeScopes::Transaction.paid_within("2021-06-22T23:59:59", "2021-06-24T:00:00:01").count)
  end

  def test_not_within
    assert_equal(2, TypeScopes::Transaction.paid_not_within("2021-06-23T00:00:00", "2021-06-24").count)
    assert_equal(0, TypeScopes::Transaction.paid_not_within("2021-06-22T23:59:59", "2021-06-24T:00:00:01").count)
  end
end
