# frozen_string_literal: true
require 'csv'

namespace :data  do
  desc "Import students data from CSV file"
  task :import_student_data_from_csv, [:file] => :environment do |_, args|
    # raise "No file specified" unless args[:file].present?
    file_path = args[:file] || '/Users/jian/Desktop/test/students.csv'
    student_attributes = []
    student_tasks_attributes = []
    CSV.foreach(file_path, headers: true, converters: [lambda { |field| field.nil? || field.empty? ? nil : field }], quote_char: '"', col_sep: ';') do |row|
      r = row.to_h
      if r['id'].blank? || r['salary_rate'].blank? || r['house'].blank?
        pp r
        next
      end

      # students
      student_attributes << { uuid: r['id'], salary_rate: r['salary_rate'].to_i, after_17_extra_salary_rate: r['after_17_extra_salary_rate'].to_i, house: r['house'] }
      # student_tasks_attributes
      r['tasks'].split(";").each {|n|  student_tasks_attributes << { task_name: n, student_uuid: r['id'] } }
    end
    Student.upsert_all(student_attributes)
    StudentTask.upsert_all(student_tasks_attributes)
    puts "Student Data imported successfully from #{file_path}"
  end

  desc "Import shifts data from CSV file"
  task :import_shifts_data_from_csv, [:file] => :environment do |_, args|
    # raise "No file specified" unless args[:file].present?

    file_path = args[:file] || '/Users/jian/Desktop/test/shifts.csv'
    shifts_attributes = []
    CSV.foreach(file_path, headers: true, converters: [lambda { |field| field.nil? || field.empty? ? nil : field }], quote_char: '"', col_sep: ';') do |row|
      r = row.to_h
      if r['id'].blank? || r['start_time'].blank? || r['end_time'].blank? || r['billable_rate'].blank? || r['appointed_by'].blank?
        pp r
        next
      end
      shifts_attributes << { uuid: r['id'], start_time: r['start_time'], end_time: r['end_time'], unpaid_break_minutes: r['unpaid_break'].to_i, billable_rate: r['billable_rate'], appointed_by: r['appointed_by'] }
    end
    Shift.upsert_all(shifts_attributes)
    puts "Shifts Data imported successfully from #{file_path}"
  end
end
