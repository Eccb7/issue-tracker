class ReportsController < ApplicationController
  def show
    @issues = Issue.includes(:project).order(created_at: :desc)
    @issues_by_status  = Issue.group(:status).count
    @issues_by_project = Issue.group(:project_id).count.transform_keys { |pid| Project.find(pid).title }

    respond_to do |format|
      format.html
      format.xlsx
      format.pdf do
        render pdf: "issues_report",
               template: "reports/pdf",
               layout: "pdf"
      end
    end
  end
end
