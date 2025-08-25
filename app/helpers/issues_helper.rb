module IssuesHelper
  def display_status(issue)
  return "New" if issue.status == "new_issue"
    issue.status.humanize
  end
end
