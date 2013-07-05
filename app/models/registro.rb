class Registro
  def initialize
    @ws = worksheet
  end

  def worksheet
    session = GoogleDrive.login(ENV['gmail'], ENV['gmailp'])
    session.spreadsheet_by_title("TestRegistro").worksheet_by_title("Registro")
  end

  def add_row row
    last_row = @ws.rows[@ws.num_rows - 1]
    @ws.update_cells(@ws.num_rows + 1, 1, [row.cell_values + generate_formulas])
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
end
