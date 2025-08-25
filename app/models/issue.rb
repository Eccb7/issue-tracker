class Issue < ApplicationRecord
  belongs_to :project

  validates :title, presence: true
  validates :description, presence: true

  # Define status enum
  enum :status, {
    new_issue: 0,
    pending: 1,
    in_progress: 2,
    resolved: 3,
    closed: 4
  }

  # Priority is now a regular integer field (1-5)
  validates :priority, presence: true, inclusion: { in: 1..5 }

  # Helper method to get priority label
  def priority_label
    case priority
    when 1 then "Very Low"
    when 2 then "Low"
    when 3 then "Medium"
    when 4 then "High"
    when 5 then "Critical"
    else "Unknown"
    end
  end

  # Helper method to get priority color class
  def priority_color
    case priority
    when 1 then "bg-gray-100 text-gray-800"
    when 2 then "bg-blue-100 text-blue-800"
    when 3 then "bg-yellow-100 text-yellow-800"
    when 4 then "bg-orange-100 text-orange-800"
    when 5 then "bg-red-100 text-red-800"
    else "bg-gray-100 text-gray-800"
    end
  end

  def self.by_status
    group(:status).count
  end

  def self.by_project
    group(:project_id).count
  end

  def mark_as_closed
    update(status: :closed)
  end

  def mark_as_in_progress
    update(status: :in_progress)
  end

  def mark_as_new_issue
    update(status: :new_issue)
  end
end
