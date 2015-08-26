module HasSkills
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :skills
    validates :skills, presence: true

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
