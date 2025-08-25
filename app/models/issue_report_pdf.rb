class IssueReportPdf < Prawn::Document
  def initialize(issues)
    super(page_size: "A4", page_layout: :portrait)
    @issues = issues
    generate_content
  end

  def generate_content
    # Add a title
    text "Issues Report", size: 24, style: :bold, align: :center
    move_down 20

    # Add the current date
    text "Generated on: #{Time.now.strftime("%B %d, %Y")}", align: :right
    move_down 30

    # Add a summary section
    summary_section
    move_down 20

    # Add the issues table
    issues_table
    move_down 20

    # Add page numbers
    number_pages "<page> of <total>", { start_count_at: 1, page_filter: :all, at: [bounds.right - 50, 0], align: :right }
  end

  def summary_section
    text "Summary", size: 16, style: :bold
    move_down 10

    status_counts = @issues.group_by(&:status).transform_values(&:count)
    priority_counts = @issues.group_by(&:priority).transform_values(&:count)

    text "Total Issues: #{@issues.count}", size: 12
    move_down 5

    text "Status Breakdown:", size: 12
    status_counts.each do |status, count|
      text "  • #{status}: #{count}", size: 10
    end
    move_down 5

    text "Priority Breakdown:", size: 12
    priority_counts.each do |priority, count|
      text "  • #{priority}: #{count}", size: 10
    end
  end

  def issues_table
    text "Issues List", size: 16, style: :bold
    move_down 10

    # Define the table data
    table_data = [["ID", "Title", "Status", "Priority", "Created"]]
    @issues.each do |issue|
      table_data << [
        issue.id.to_s,
        issue.title,
        issue.status.to_s,
        issue.priority.to_s,
        issue.created_at.strftime("%Y-%m-%d")
      ]
    end
class IssueReportPdf < Prawn::Document
  def initialize(issues)
    super(page_size: "A4", page_layout: :portrait)
    @issues = issues
    generate_content
  end

  def generate_content
    # Add a title
    text "Issues Report", size: 24, style: :bold, align: :center
    move_down 20

    # Add the current date
    text "Generated on: #{Time.now.strftime("%B %d, %Y")}", align: :right
    move_down 30

    # Add a summary section
    summary_section
    move_down 20

    # Add the issues table
    issues_table
    move_down 20

    # Add page numbers
    number_pages "<page> of <total>", { start_count_at: 1, page_filter: :all, at: [bounds.right - 50, 0], align: :right }
  end

  def summary_section
    text "Summary", size: 16, style: :bold
    move_down 10

    status_counts = @issues.group_by(&:status).transform_values(&:count)
    priority_counts = @issues.group_by(&:priority).transform_values(&:count)

    text "Total Issues: #{@issues.count}", size: 12
    move_down 5

    text "Status Breakdown:", size: 12
    status_counts.each do |status, count|
      text "  • #{status}: #{count}", size: 10
    end
    move_down 5

    text "Priority Breakdown:", size: 12
    priority_counts.each do |priority, count|
      text "  • #{priority}: #{count}", size: 10
    end
  end

  def issues_table
    text "Issues List", size: 16, style: :bold
    move_down 10

    # Define the table data
    table_data = [["ID", "Title", "Status", "Priority", "Created"]]
    @issues.each do |issue|
      table_data << [
        issue.id.to_s,
        issue.title,
        issue.status.to_s,
        issue.priority.to_s,
        issue.created_at.strftime("%Y-%m-%d")
      ]
    end
# This file is being removed
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
