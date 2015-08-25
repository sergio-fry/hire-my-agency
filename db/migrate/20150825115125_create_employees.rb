class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.integer :status
      t.float :salary

      t.timestamps null: false
    end
  end
end
