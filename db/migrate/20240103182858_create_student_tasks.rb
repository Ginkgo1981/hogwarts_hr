class CreateStudentTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :student_tasks do |t|
      t.string :task_name, null: false
      t.string :student_uuid, null: false, foreign_key: true

      # t.timestamps
    end

    add_index :student_tasks, :task_name
    add_index :student_tasks, :student_uuid

    add_index :student_tasks, [:task_name, :student_uuid], unique: true
  end
end
