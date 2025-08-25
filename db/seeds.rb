
# Create sample projects
projects = [
  { title: "Atlas", description: "Core platform for all business logic." },
  { title: "Nimbus", description: "Mobile app for field operations." },
  { title: "Helios", description: "Analytics and reporting engine." }
]

project_records = projects.map { |attrs| Project.create!(attrs) }

# Create sample issues for each project
issue_samples = [
  {
    title: "Login page error",
    description: "Users are unable to log in due to a server error.",
  status: "new_issue",
    priority: 1
  },
  {
    title: "Dashboard slow loading",
    description: "Dashboard takes more than 10 seconds to load for some users.",
    status: "in_progress",
    priority: 3
  },
  {
    title: "Export to PDF broken",
    description: "PDF export fails with a timeout error.",
    status: "closed",
    priority: 2
  },
  {
    title: "Notification emails not sent",
    description: "Some users do not receive notification emails.",
    status: "pending",
    priority: 4
  },
  {
    title: "Mobile app crashes on launch",
    description: "App crashes immediately after opening on Android devices.",
    status: "in_progress",
    priority: 5
  }
]

project_records.each do |project|
  issue_samples.each do |issue_attrs|
    Issue.create!(issue_attrs.merge(project: project))
  end
end
