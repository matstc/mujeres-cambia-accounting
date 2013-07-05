class AccountingRow
  attr_accessor :date, :id, :description, :amount, :account
  
  def initialize params
    @id, @description, @amount, @account = *params
    @date = Date.today
  end

  def self.create_transfer params
    id, amount, account1, account2 = *params
    [ 
      AccountingRow.new([id, I18n.t("transfer"), 0 - amount.to_f, account1]), 
      AccountingRow.new([id, I18n.t("transfer"), amount.to_f, account2])
    ]
  end

  def cell_values
    incoming = nil
    outgoing = nil
    if @amount.to_f > 0
      incoming = @amount.to_f
    else
      outgoing = @amount.to_f.abs
    end

    [I18n.localize(@date), @id, @description, incoming, outgoing, @account]
  end

end
