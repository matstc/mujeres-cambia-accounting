require 'test_helper'
 
class PostTest < ActiveSupport::TestCase
  test "accounting row sets its creation date automatically" do
     row = AccountingRow.new []
     refute(row.date.nil?)
  end

  test "accounting row sets the value of the correct column when amount is negative" do
    row = AccountingRow.new([1,"description",-1,"account"])
    assert_equal(row.cell_values.drop(1), [1,"description",nil,1.0,"account"])
  end

  test "accounting row sets the value of the correct column when amount is positive" do
    row = AccountingRow.new([1,"description",1,"account"])
    assert_equal(row.cell_values.drop(1), [1,"description",1.0,nil,"account"])
  end

  test "creates two rows to execute a transfer between two accounts" do
    rows = AccountingRow.create_transfer([1,5,"account1","account2"])
    assert_equal(rows.size, 2)
    assert_equal(rows[0].cell_values.drop(1), [1,"transfer",nil,5.0,"account1"])
    assert_equal(rows[1].cell_values.drop(1), [1,"transfer",5.0,nil,"account2"])
  end
end
