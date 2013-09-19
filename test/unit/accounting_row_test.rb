require 'test_helper'
 
class PostTest < ActiveSupport::TestCase
  test "accounting row sets its creation date automatically" do
     row = AccountingRow.new []
     refute(row.date.nil?)
  end

  test "accounting row sets the value of the correct column when amount is negative" do
    row = AccountingRow.new(["#1","description",-1,"account"])
    assert_equal(["1","description",nil,1.0,"account"], row.cell_values.drop(1))
  end

  test "accounting row sets the value of the correct column when amount is positive" do
    row = AccountingRow.new(["#1","description",1,"account"])
    assert_equal(["1","description",1.0,nil,"account"], row.cell_values.drop(1))
  end

  test "creates two rows to execute a transfer between two accounts" do
    rows = AccountingRow.create_transfer(["#1",5,"account1","account2"])
    assert_equal(rows.size, 2)
    assert_equal(["1","transferencia",nil,5.0,"account1"], rows[0].cell_values.drop(1))
    assert_equal(["1","transferencia",5.0,nil,"account2"], rows[1].cell_values.drop(1))
  end

  test "creates a transfer without an ID" do
    rows = AccountingRow.create_transfer([5, "account1", "account2"])
    assert_equal(rows.size, 2)
    assert_equal([nil,"transferencia",nil,5.0,"account1"], rows[0].cell_values.drop(1))
    assert_equal([nil,"transferencia",5.0,nil,"account2"], rows[1].cell_values.drop(1))
  end

  test "creates a row without an ID" do
    row = AccountingRow.new(["description", 1, "account"])
    assert_equal([nil,"description",1.0,nil,"account"], row.cell_values.drop(1))
  end

  test "validates basic accounting row" do
    row = AccountingRow.new(["description", 1, "account"])
    assert_equal(true, row.is_valid?(["account"]))
  end

  test "invalidates accounting row without enough information" do
    row = AccountingRow.new(["description", 1])
    assert_equal(false, row.is_valid?(["account"]))
  end

  test "invalidates accounting row if quantity is not a number" do
    row = AccountingRow.new(["description", "a", "account"])
    assert_equal(false, row.is_valid?(["account"]))
  end
end
