class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.float :expires_in_days
      t.float :salary
      t.text :contacts

      t.timestamps null: false
    end
  end
end
