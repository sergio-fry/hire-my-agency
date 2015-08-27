module HasSkills
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :skills
    validates :skills, presence: true
  end

  def skills=(new_skills)
    super(new_skills.uniq)
  end

  def skills_list
    skills.map(&:title).join(", ")
  end

  def skills_list=(new_skills_list)
    self.skills = new_skills_list.split(",").map(&:strip).reject(&:blank?).compact.map { |title| Skill.find_or_create_by(title: title) }
  end
end
