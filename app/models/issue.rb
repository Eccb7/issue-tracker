class Issue < ApplicationRecord
  belongs_to :project

  validates :title, presence: true
  validates :description, presence: true
  validates :status, presence: true

  enum status: { new_: 0, in_progress: 1, closed: 2 }, _prefix: :status
  validates :title, presence: true
  validates :priority, inclusion: { in: 1..5 }

  scope :by_status, -> { group(:status).count }
  scope :by_project, -> { group(:project_id).count }

  def mark_as_closed
    update(status: :closed)
  end

  def mark_as_in_progress
    update(status: :in_progress)
  end

  def mark_as_new
    update(status: :new_)
  end
end
