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
end
