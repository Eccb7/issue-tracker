require 'prawn'
require 'prawn/table'

class IssueReportPdf < Prawn::Document
  def initialize(issues)
    super(page_size: "A4", page_layout: :portrait)
    @issues = issues
    generate_content
  end

  def generate_content
    add_header
    add_summary
    add_issues_table
    add_footer
  end

  def add_header
    text "Issues Report", size: 24, style: :bold, align: :center
    move_down 20
    text "Generated on: #{Time.now.strftime("%B %d, %Y")}", align: :right
    move_down 30
  end

  def add_summary
    text "Summary", size: 16, style: :bold
    move_down 10

    # Safe access to status and priority
    status_counts = @issues.group_by { |i| i.try(:status) }.transform_values(&:count)
    priority_counts = @issues.group_by { |i| i.try(:priority) }.transform_values(&:count)

    text "Total Issues: #{@issues.count}", size: 12
    move_down 5

    text "Status Breakdown:", size: 12
    status_counts.each do |status, count|
      next if status.nil?
      text "  • #{status}: #{count}", size: 10
    end
    move_down 5

    text "Priority Breakdown:", size: 12
    priority_counts.each do |priority, count|
      next if priority.nil?
      text "  • #{priority}: #{count}", size: 10
    end
    move_down 20
  end

  def add_issues_table
    text "Issues List", size: 16, style: :bold
    move_down 10

    # Define the table data
    table_data = [["ID", "Title", "Status", "Priority", "Created"]]

    @issues.each do |issue|
      table_data << [
        issue.id.to_s,
        issue.try(:title).to_s,
        issue.try(:status).to_s,
        issue.try(:priority).to_s,
        issue.created_at&.strftime("%Y-%m-%d").to_s
      ]
    end

    # Create the table
    if table_data.size > 1
      table(table_data, width: bounds.width) do |t|
        t.row(0).font_style = :bold
        t.row(0).background_color = "DDDDDD"
        t.header = true
        t.row_colors = ["FFFFFF", "F0F0F0"]
        t.cell_style = { padding: [5, 5, 5, 5] }
      end
    else
      text "No issues found", size: 12, style: :italic
    end
  end

  def add_footer
    move_down 20
    number_pages "<page> of <total>", 
                { start_count_at: 1, page_filter: :all, at: [bounds.right - 50, 0], align: :right }
  end
end
