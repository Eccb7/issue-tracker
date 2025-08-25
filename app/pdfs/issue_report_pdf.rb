# This file is deprecated. Using app/models/issue_report_pdf.rb instead.
    # Create the table
    table(table_data, width: bounds.width) do
      row(0).font_style = :bold
      row(0).background_color = "DDDDDD"
      self.header = true
      self.row_colors = ["FFFFFF", "F0F0F0"]
      self.cell_style = { padding: [5, 5, 5, 5] }
      columns(0).width = 30
      columns(2..3).width = 70
      columns(4).width = 70
    end
  end
end
