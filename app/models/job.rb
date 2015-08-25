class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :created_at, presence: true
  validates :contacts, presence: true
  validates :expires_in_days, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }

  has_and_belongs_to_many :skills
  validates :skills, presence: true
end
