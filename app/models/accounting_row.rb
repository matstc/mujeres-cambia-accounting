class AccountingRow
  attr_accessor :date, :id, :description, :amount, :account
  
  def initialize params
    @id, @description, @amount, @account = *params
    @date = Time.now
  end

  def self.create_transfer params
    id, amount, account1, account2 = *params
    [ 
      AccountingRow.new([id, "transfer", 0 - amount.to_f, account1]), 
      AccountingRow.new([id, "transfer", amount.to_f, account2])
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

    [@date, @id, @description, incoming, outgoing, @account]
  end

end
