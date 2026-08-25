class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :location
      t.integer :salary_min
      t.integer :salary_max
      t.string :employment_type
      t.string :status
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
