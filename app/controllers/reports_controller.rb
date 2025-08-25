## ReportsController: Handles report generation and export (HTML, PDF, XLSX)
class ReportsController < ApplicationController
  # Show general report in HTML, PDF, or XLSX format
  def show
    @issues_by_status  = Issue.group(:status).count
    @issues_by_project = Issue.group(:project_id).count.transform_keys { |pid| Project.find(pid).title }
    @issues = Issue.includes(:project).all

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "show", filename: "issues_report.xlsx" }
      format.pdf do
        # Generate PDF using Prawn for now
        pdf = Prawn::Document.new
        pdf.text "Issues Report", size: 24, style: :bold, align: :center
        pdf.move_down 20
        pdf.text "Generated on: #{Time.now.strftime('%B %d, %Y')}", align: :right
        pdf.move_down 30

        # Summary
        pdf.text "Summary", size: 16, style: :bold
        pdf.move_down 10
        pdf.text "Total Issues: #{@issues.count}", size: 12

        # Add status breakdown
        status_counts = @issues.group_by(&:status).transform_values(&:count)
        pdf.move_down 10
        pdf.text "Status Breakdown:", size: 12
        status_counts.each do |status, count|
          pdf.text "  • #{status || 'Unknown'}: #{count}", size: 10
        end

        # Table
        pdf.move_down 20
        pdf.text "Issues List", size: 16, style: :bold
        pdf.move_down 10

        data = [["ID", "Title", "Status", "Priority", "Created"]]
        @issues.each do |issue|
          data << [
            issue.id.to_s,
            issue.title.to_s,
            issue.status.to_s,
            issue.priority.to_s,
            issue.created_at.strftime('%Y-%m-%d')
          ]
        end

        pdf.table(data, header: true) do |table|
          table.row(0).font_style = :bold
          table.row(0).background_color = "DDDDDD"
        end

        send_data pdf.render, 
                  filename: "issues_report.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  # Show per-project report in HTML, PDF, or XLSX format
  def project
    @project = Project.find(params[:id])
    @issues = @project.issues
    @issues_by_status = @issues.group(:status).count

    # Make sure groupdate gem is working
    Rails.logger.info "Testing groupdate: #{@issues.group_by_day(:created_at).count.inspect}"

    # Print available attributes for debugging
    Rails.logger.info "Project attributes: #{@project.attributes.keys}"

    respond_to do |format|
      format.html { render :project }
      format.xlsx { render xlsx: "project", filename: "project_issues_report.xlsx" }
      format.pdf do
        # Fall back to Prawn for now since HTML PDF rendering requires additional setup
        pdf = Prawn::Document.new

        # Project title - safely get the project name or fallback to ID
        project_title = @project.try(:name) || @project.try(:title) || "Project ##{@project.id}"

        pdf.text "Project Report: #{project_title}", size: 24, style: :bold, align: :center
        pdf.move_down 20
        pdf.text "Generated on: #{Time.now.strftime('%B %d, %Y')}", align: :right
        pdf.move_down 30

        # Project details
        pdf.text "Project Details", size: 16, style: :bold
        pdf.move_down 10
        pdf.text "Name: #{project_title}", size: 12
        pdf.text "Total Issues: #{@issues.count}", size: 12

        # Add status breakdown
        status_counts = @issues.group_by(&:status).transform_values(&:count)
        pdf.move_down 10
        pdf.text "Status Breakdown:", size: 12
        status_counts.each do |status, count|
          pdf.text "  • #{status || 'Unknown'}: #{count}", size: 10
        end

        pdf.move_down 20

        # Table
        pdf.text "Issues List", size: 16, style: :bold
        pdf.move_down 10

        data = [["ID", "Title", "Status", "Priority", "Created"]]
        @issues.each do |issue|
          data << [
            issue.id.to_s,
            issue.title.to_s,
            issue.status.to_s,
            issue.priority.to_s,
            issue.created_at.strftime('%Y-%m-%d')
          ]
        end

        pdf.table(data, header: true) do |table|
          table.row(0).font_style = :bold
          table.row(0).background_color = "DDDDDD"
        end

        send_data pdf.render, 
                  filename: "project_issues_report.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end
end
