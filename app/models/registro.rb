class Registro
  def initialize
    @ws = worksheet
  end

  def state_of_one_account account_string
    account_name = account_string[0]
    account_names = @ws.list[0].keys.map{|k| k.downcase}
    column = account_names.index(account_name.downcase)
    raise Exception.new(I18n.t("response.invalid_account", :name => account_name)) if column.nil?

    "#{@ws.list[0].keys[column]}: #{@ws[@ws.num_rows, column + 1]}"
  end

  def state_of_all_accounts *args
    (7..@ws.num_cols).map{|column|
      name = @ws[1, column]
      state = @ws[@ws.num_rows, column]
      "#{name}: #{state}"
    }.join("; ")
  end

  def add_row row_string
    row = AccountingRow.new row_string
    raise Exception.new(I18n.t("response.invalid_row")) if not row.is_valid?

    add_accounting_row row
    I18n.t("response.success")
  end

  def transfer row_strings
    rows = AccountingRow.create_transfer(row_strings)
    raise Exception.new(I18n.t("response.invalid_transfer")) if not rows.all? {|row| row.is_valid?}

    rows.each{|row| add_accounting_row(row)}
    I18n.t("response.success")
  end

  private
  def add_accounting_row accounting_row
    @ws.update_cells(@ws.num_rows + 1, 1, [accounting_row.cell_values + generate_formulas])
    @ws.save
  end

  # It would be nice to just copy the formulas from the row above but I could not find a way
  # to make it work. The API returns the formulas in R1C1 notation and accepts formulas in A1
  # notation. There is an attempt to translate from R1C1 to A1 but it does not work for 
  # ambiguous column names like RC1 which is valid in both notations.
  #
  # A better solution would be to have a converter from R1C1 to A1 and use that to copy the 
  # formulas to the row below.
  def generate_formulas
    column_letter = "G"
    column_index = 7
    formulas = []

    while column_index <= @ws.num_cols
      formulas += ["=if(X$1=$F#{@ws.num_rows + 1},X#{@ws.num_rows}+$D#{@ws.num_rows + 1}-$E#{@ws.num_rows + 1},if((isblank($C#{@ws.num_rows + 1})),\" \",X#{@ws.num_rows}))".gsub("X", column_letter)]
      column_index = column_index + 1
      column_letter = column_letter.succ
    end

    formulas
  end

  def worksheet
    session = GoogleDrive.login(ENV['gmail'], ENV['gmailp'])
    session.spreadsheet_by_title("TestRegistro").worksheet_by_title("Registro")
  end

end
