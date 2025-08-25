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
      format.pdf { render pdf: "issues_report", template: "reports/pdf.html.erb", layout: "pdf" }
    end
  end

  # Show per-project report in HTML, PDF, or XLSX format
  def project
    @project = Project.find(params[:id])
    @issues = @project.issues
    @issues_by_status = @issues.group(:status).count

    respond_to do |format|
      format.html { render :project }
      format.xlsx { render xlsx: "project", filename: "project_issues_report.xlsx" }
      format.pdf { render pdf: "project_issues_report", template: "reports/pdf.html.erb", layout: "pdf" }
    end
  end
end
