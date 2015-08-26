class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :title
    end

    create_table :jobs_skills do |t|
      t.integer :job_id
      t.integer :skill_id
    end

    add_foreign_key :jobs_skills, :jobs
    add_foreign_key :jobs_skills, :skills
    add_index :jobs_skills, [:job_id, :skill_id], :unique => true

    create_table :employees_skills do |t|
      t.integer :employee_id
      t.integer :skill_id
    end


    add_foreign_key :employees_skills, :employees
    add_foreign_key :employees_skills, :skills
    add_index :employees_skills, [:employee_id, :skill_id], :unique => true
  end
end
