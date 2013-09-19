class AccountingRow
  attr_accessor :date, :id, :description, :amount, :account
  
  def self.parse params
    if params.join.start_with?("#")
      params
    else
      [nil, *params]
    end
  end

  def self.drop_nil_id array
    array[0].nil? ? array.drop(1) : array
  end

  def self.create_transfer params
    id, amount, account1, account2 = AccountingRow.parse(params)
    [ 
      AccountingRow.new(AccountingRow.drop_nil_id([id, I18n.t("transfer"), 0 - amount.to_f, account1])), 
      AccountingRow.new(AccountingRow.drop_nil_id([id, I18n.t("transfer"), amount.to_f, account2]))
    ]
  end

  def initialize params
    @id, @description, @amount, @account = AccountingRow.parse(params)
    @date = Date.today
  end

  def errors account_names
    errors = []
    errors << "invalid_row.description_blank" if @description.blank? 
    errors << "invalid_row.amount_blank" if @amount.blank? 
    errors << "invalid_row.amount_not_a_number" if !@amount.blank? and !@amount.to_s.is_number?
    errors << "invalid_row.account_blank" if @account.blank?
    errors << "invalid_row.account_not_found" if !account_names.include?(@account)
    errors
  end

  def is_valid? account_names
    errors(account_names).empty?
  end

  def cell_values
    incoming = nil
    outgoing = nil
    if @amount.to_f > 0
      incoming = @amount.to_f
    else
      outgoing = @amount.to_f.abs
    end

    [I18n.localize(@date), @id.nil? ? @id : @id.sub(/^#/,''), @description, incoming, outgoing, @account]
  end
end
