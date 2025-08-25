## Project: Model for tracking projects
class Project < ApplicationRecord
  # Each project can have many issues
  has_many :issues, dependent: :destroy
  # Title is required
  validates :title, presence: true
end
