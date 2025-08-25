## Issue: Model for tracking issues within projects
class Issue < ApplicationRecord
  # Each issue belongs to a project
  belongs_to :project

  # Validations for required fields
  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true

  # Status enum (uncomment and fix if needed)
  # enum status: { new: 0, in_progress: 1, closed: 2 }
  validates :title, presence: true
  validates :priority, inclusion: { in: 1..5 }

  # Returns a hash of issue counts by status
  def self.by_status
    group(:status).count
  end

  # Returns a hash of issue counts by project
  def self.by_project
    group(:project_id).count
  end

  # Mark issue as closed
  def mark_as_closed
    update(status: :closed)
  end

  # Mark issue as in progress
  def mark_as_in_progress
    update(status: :in_progress)
  end

  # Mark issue as new
  def mark_as_new
    update(status: :new)
  end
end
