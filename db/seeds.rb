# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
p1 = Project.create!(title: "Atlas", description: "Core platform")
p2 = Project.create!(title: "Nimbus", description: "Mobile app")
20.times do |i|
  Issue.create!(
    title: "Issue ##{i + 1}",
    status: Issue.statuses.keys.sample,
    priority: (1..5).to_a.sample,
    project: [p1, p2].sample
  )
end
