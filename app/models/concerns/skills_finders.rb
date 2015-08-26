module SkillsFinders
  extend ActiveSupport::Concern

  included do
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
end
