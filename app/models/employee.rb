class Employee < ActiveRecord::Base
  validates :name, presence: true, format: { with: /\A[а-я ]+\z/im }
  validates :name_parts, length: { is: 3, message: "Name should have exact 3 words" }

  validates :email, :email => {:strict_mode => true}, :unless => lambda { email.blank? }
  validates :phone, :format => { with: /[[:digit:]]+/, allow_nil: true }
  validates :contacts, presence: true

  validates :salary, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true

  include HasSkills

  scope :with_skills, lambda { |skill_ids, match| 
    match = [1.0, match.abs].min

    # OPTIMIZE: достаточно делать join только связующей таблицы
    ids = select("#{table_name}.id, COUNT(skills.id)")
    .joins(:skills).where(skills: { id: skill_ids })
    .group("#{table_name}.id")
    .having("COUNT(skills.id) >= #{match.to_f * skill_ids.size.to_f} AND COUNT(skills.id) > 0")
    .pluck(:id)

    where(id: ids)
  }

  STATUS_NEED_JOB = 0
  STATUS_GOT_JOB = 1

  def contacts
    [email, phone].compact.join(", ")
  end

  private

  def name_parts
    name.to_s.split
  end
end
