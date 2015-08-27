class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :created_at, presence: true
  validates :contacts, presence: true
  validates :expires_in_days, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }

  include HasSkills
  before_save lambda { self.skills_cnt = skills.size }

  scope :with_less_skills_than, lambda { |skill_ids, match| 
    match = [1.0, match.abs].min

    # OPTIMIZE: достаточно делать join только связующей таблицы
    ids = select("#{table_name}.id, COUNT(skills.id)")
    .joins(:skills).where(skills: { id: skill_ids })
    .group("#{table_name}.id")
    .having("COUNT(skills.id) >= #{match.to_f} * jobs.skills_cnt AND COUNT(skills.id) > 0")
    .pluck(:id)

    where(id: ids)
  }

  before_save :set_expires_at

  private

  def set_expires_at
    self.expires_at = created_at + expires_in_days.days
  end
end
