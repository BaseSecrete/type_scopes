require File.expand_path("../../test_helper", __FILE__)

class TypeScopes::StringTest < TypeScopes::TestCase
  def setup
    TypeScopes::Transaction.connection.truncate(TypeScopes::Transaction.table_name)
    TypeScopes::Transaction.create!(amount: 100, paid_at: "2021-06-23", description: "Lorem ipsum")
    TypeScopes::Transaction.create!(amount: 200, paid_at: "2021-06-24", description: "Lorem ipsum")
  end

  def test_like
    assert_equal(2, TypeScopes::Transaction.description_like("%Lorem%").count)
    return unless sql_adapter_like_case_sensitive?
    assert_equal(0, TypeScopes::Transaction.description_like("%LOREM%").count)
    assert_equal(2, TypeScopes::Transaction.description_like("%LOREM%", sensitive: false).count)
  end

  def test_not_like
    assert_equal(0, TypeScopes::Transaction.description_not_like("%ipsum").count)
    return unless sql_adapter_like_case_sensitive?
    assert_equal(2, TypeScopes::Transaction.description_not_like("%IPSUM").count)
    assert_equal(0, TypeScopes::Transaction.description_not_like("%IPSUM", sensitive: false).count)
  end

  def test_ilike
    assert_equal(0, TypeScopes::Transaction.description_ilike("%xxx%").count)
    assert_equal(2, TypeScopes::Transaction.description_ilike("LOREM%").count)
  end

  def test_not_ilike
    assert_equal(0, TypeScopes::Transaction.description_not_ilike("%IPSUM").count)
    assert_equal(2, TypeScopes::Transaction.description_not_ilike("%xxx%").count)
  end

  def test_contains
    assert_equal(2, TypeScopes::Transaction.description_contains("m i").count)
    assert_equal(0, TypeScopes::Transaction.description_contains("xxx").count)
  end

  def test_does_not_contain
    assert_equal(0, TypeScopes::Transaction.description_does_not_contain("m i").count)
    assert_equal(2, TypeScopes::Transaction.description_does_not_contain("xxx").count)
  end

  def test_starts_with
    assert_equal(2, TypeScopes::Transaction.description_starts_with("Lorem").count)
    assert_equal(2, TypeScopes::Transaction.description_starts_with("LOREM", sensitive: false).count)
    return unless sql_adapter_like_case_sensitive?
    assert_equal(0, TypeScopes::Transaction.description_starts_with("LOREM").count)
  end

  def test_does_not_start_with
    assert_equal(0, TypeScopes::Transaction.description_does_not_start_with("Lorem").count)
    assert_equal(0, TypeScopes::Transaction.description_does_not_start_with("LOREM", sensitive: false).count)
    return unless sql_adapter_like_case_sensitive?
    assert_equal(2, TypeScopes::Transaction.description_does_not_start_with("LOREM").count)
  end

  def test_ends_with
    assert_equal(2, TypeScopes::Transaction.description_ends_with("ipsum").count)
    assert_equal(2, TypeScopes::Transaction.description_ends_with("IPSUM", sensitive: false).count)
    return unless sql_adapter_like_case_sensitive?
    assert_equal(0, TypeScopes::Transaction.description_ends_with("IPSUM").count)
  end

  def test_does_not_end_with
    assert_equal(0, TypeScopes::Transaction.description_does_not_end_with("ipsum").count)
    assert_equal(0, TypeScopes::Transaction.description_does_not_end_with("IPSUM", sensitive: false).count)
    return unless sql_adapter_like_case_sensitive?
    assert_equal(2, TypeScopes::Transaction.description_does_not_end_with("IPSUM").count)
  end

  def test_escaped_characters
    assert_equal(0, TypeScopes::Transaction.description_contains("%").count)
    assert_equal(0, TypeScopes::Transaction.description_contains("_").count)
  end

  def test_matches
    skip unless sql_adapter_supports_regex?
    assert_equal(2, TypeScopes::Transaction.description_matches("Lorem.").count)
    assert_equal(2, TypeScopes::Transaction.description_matches("LOREM.", sensitive: false).count)
    assert_equal(0, TypeScopes::Transaction.description_matches("LOREM.").count)
  end

  def test_does_not_match
    skip unless sql_adapter_supports_regex?
    assert_equal(0, TypeScopes::Transaction.description_does_not_match("Lorem.").count)
    assert_equal(0, TypeScopes::Transaction.description_does_not_match("LOREM.", sensitive: false).count)
    assert_equal(2, TypeScopes::Transaction.description_does_not_match("LOREM.").count)
  end
end
