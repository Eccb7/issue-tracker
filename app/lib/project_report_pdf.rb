require 'prawn'
require 'prawn/table'

class ProjectReportPdf < Prawn::Document
  def initialize(project, issues)
    super(page_size: "A4", page_layout: :portrait)
    @project = project
    @issues = issues
    generate_content
  end

  def generate_content
    add_header
    add_project_details
    add_summary
    add_issues_table
    add_footer
  end

  def add_header
    # Try both name and title for flexibility
    project_title = @project.respond_to?(:name) ? @project.name : 
                    (@project.respond_to?(:title) ? @project.title : "Project")

    text "Project Report: #{project_title}", size: 24, style: :bold, align: :center
    move_down 20
    text "Generated on: #{Time.now.strftime("%B %d, %Y")}", align: :right
    move_down 30
  end

  def add_project_details
    text "Project Details", size: 16, style: :bold
    move_down 10

    # Try both name and title for flexibility
    project_title = @project.respond_to?(:name) ? @project.name : 
                    (@project.respond_to?(:title) ? @project.title : "Project")

    text "Name: #{project_title}", size: 12

    if @project.respond_to?(:description) && @project.description.present?
      text "Description: #{@project.description}", size: 12
    end

    if @project.respond_to?(:created_at) && @project.created_at
      text "Created: #{@project.created_at.strftime("%B %d, %Y")}", size: 12
    end

    move_down 20
  end

  def add_summary
    text "Issue Summary", size: 16, style: :bold
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
