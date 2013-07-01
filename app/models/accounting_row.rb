class AccountingRow
  attr_accessor :date, :id, :description, :amount, :account
  
  def initialize string
    @id, @description, @amount, @account = string.split(",")
    @date = Time.now
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
