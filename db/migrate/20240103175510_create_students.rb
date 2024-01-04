class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :uuid
      t.integer :salary_rate
      t.integer :after_17_extra_salary_rate
      t.string :house

      # t.timestamps
    end

    add_index :students, :uuid, unique: true
    add_index :students, :house
  end
end
