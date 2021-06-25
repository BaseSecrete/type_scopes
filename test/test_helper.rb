$LOAD_PATH.unshift(File.expand_path("../../lib", __FILE__))

require "active_record"
require "type_scopes"
require "minitest/autorun"

class TypeScopes::Transaction < ActiveRecord::Base
  class Migration < ActiveRecord::Migration::Current
    def up
      drop_table :transactions, if_exists: true
      create_table :transactions do |t|
        t.decimal :amount, null: false
        t.datetime :paid_at
        t.string :description
        t.boolean :non_profit, null: false, default: false
        t.boolean :is_valid, null: false, default: false
        t.boolean :has_payment, null: false, default: false
        t.boolean :was_processed, null: false, default: false
      end
    end
  end
end

class TypeScopes::TestCase < Minitest::Test
  def self.initialize_database
    # "postgres:///type_scopes?user=postgres"
    ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || "sqlite3::memory:")
    ActiveRecord::Migration.verbose = false
    TypeScopes::Transaction::Migration.new.up
    TypeScopes::Transaction.include(TypeScopes)
  end

  def like_case_sensitive?
    # By default SQLite's like is case insensitive.
    # So it's not possible to have the exact same tests with other databases.
    ActiveRecord::Base.connection.adapter_name != "SQLite"
  end
end

TypeScopes::TestCase.initialize_database
