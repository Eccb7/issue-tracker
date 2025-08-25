module IssuesHelper
  def display_status(issue)
    return "New" if issue.status == "pending"
    issue.status.humanize
  end
end
