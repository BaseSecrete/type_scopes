path = File.expand_path("#{File.dirname(__FILE__)}/../lib")
$LOAD_PATH.unshift(path)

require "active_record"
require "type_scopes"
require "minitest/autorun"

class TypeScopes::Transaction < ActiveRecord::Base
  class Migration < ActiveRecord::Migration::Current
    def up
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
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Migration.verbose = false
    TypeScopes::Transaction::Migration.new.up
    TypeScopes::Transaction.include(TypeScopes)
  end
end

TypeScopes::TestCase.initialize_database
