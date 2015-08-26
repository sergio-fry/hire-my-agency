class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :created_at, presence: true
  validates :contacts, presence: true
  validates :expires_in_days, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }

  include HasSkills

  before_save :set_expires_at

  private

  def set_expires_at
    self.expires_at = created_at + expires_in_days.days
  end
end
