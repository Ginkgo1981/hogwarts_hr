# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_01_03_182858) do

  create_table "shifts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "uuid"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "unpaid_break_minutes", default: 0
    t.integer "billable_rate", default: 0
    t.string "appointed_by"
    t.index ["appointed_by"], name: "index_shifts_on_appointed_by"
    t.index ["uuid"], name: "index_shifts_on_uuid", unique: true
  end

  create_table "student_tasks", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "task_name", null: false
    t.string "student_uuid", null: false
    t.index ["student_uuid"], name: "index_student_tasks_on_student_uuid"
    t.index ["task_name", "student_uuid"], name: "index_student_tasks_on_task_name_and_student_uuid", unique: true
    t.index ["task_name"], name: "index_student_tasks_on_task_name"
  end

  create_table "students", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "uuid"
    t.integer "salary_rate"
    t.integer "after_17_extra_salary_rate"
    t.string "house"
    t.index ["house"], name: "index_students_on_house"
    t.index ["uuid"], name: "index_students_on_uuid", unique: true
  end

end
