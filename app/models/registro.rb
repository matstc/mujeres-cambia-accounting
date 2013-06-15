class Registro
  def add_row cell_values
    session = GoogleDrive.login(ENV['gmail'], ENV['gmailp'])
    ws = session.spreadsheet_by_title("Registro").worksheets[0]
    ws.update_cells(ws.num_rows + 1, 1, [cell_values.map{|v|v.strip}])
    ws.save
  end
end
