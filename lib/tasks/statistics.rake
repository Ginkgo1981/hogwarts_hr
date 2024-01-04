# frozen_string_literal: true
require 'csv'
BATCH_SIZE = 1000

namespace :statistics  do
  desc "How much should be billed per month"
  task calculate_monthly_billed: :environment do 
    monthly_billed = Hash.new(0)
    Shift.find_in_batches(batch_size: BATCH_SIZE) do |shifts|
      shifts.each do |s|
        start_time = s.start_time
        end_time = s.end_time
        # Calculate work hours
        work_hours = (end_time.to_i - start_time.to_i) / 3600
        # Calculate unpaid break hours
        unpaid_break_hours = s.unpaid_break_minutes.to_f / 60
        # Calculate billing amount
        billing_amount = (work_hours - unpaid_break_hours) * s.billable_rate
        # Extract month and year from start_time
        month_year_key = start_time.strftime('%Y-%m')
        # Accumulate billing amount for the month
        monthly_billed[month_year_key] += billing_amount
      end
    end

    monthly_billed.each do |month_year, amount|
      puts "Billed Amount for #{month_year}: $#{amount.round(2)}"
    end
  end

  desc "How much should be paid as salary per month"
  task calculate_monthly_salary: :environment do 
    monthly_paid_salary = Hash.new(0)
    Shift.includes(:student).find_in_batches(batch_size: BATCH_SIZE) do |shifts|
      shifts.each do |s|
        start_time = s.start_time
        end_time = s.end_time
        time17_utc = Time.parse("#{start_time.strftime('%Y-%m-%d')} 17:00:00 UTC")
        # Calculate work hours before 17 and Let's assume: unpaid_break only occurs before 17 o'clock
        work_hours_before_17 = end_time < time17_utc ? ((end_time.to_i - start_time.to_i) - s.unpaid_break_minutes * 60) / 3600
                                                     : ((time17_utc.to_i - start_time.to_i) - s.unpaid_break_minutes * 60) / 3600
        # Calculate work hours after 17
        work_hours_after_17 = [(end_time.to_i - time17_utc.to_i ) / 3600, 0].max
        # find rate
        student = s.student
        next if student.blank?

        rate_before_17 = student.salary_rate
        rate_after_17 = student.salary_rate + student.after_17_extra_salary_rate
        paid_amount = (work_hours_before_17 * rate_before_17) + (work_hours_after_17 * rate_after_17)
        # Extract month and year from start_time
        month_year_key = start_time.strftime('%Y-%m')
        # Accumulate billing amount for the month
        monthly_paid_salary[month_year_key] += paid_amount
      end
    end

    monthly_paid_salary.each do |month_year, amount|
      puts "salary paid for #{month_year}: $#{amount.round(2)}"
    end
  end

  desc "How many hours has each house spent cleaning pots"
  task calculate_hours_per_house: :environment do 
    sql_query = <<-SQL
      SELECT
        students.house,
        SUM(
          TIMESTAMPDIFF(SECOND, shifts.start_time, shifts.end_time) - shifts.unpaid_break_minutes * 60
        ) / 3600 AS work_hours
      FROM
        shifts
      JOIN
        students ON shifts.appointed_by = students.uuid
      JOIN
        student_tasks ON students.uuid = student_tasks.student_uuid
      WHERE
        student_tasks.task_name = 'Polishing pots'
      GROUP BY
        students.house;
  SQL

    result = ActiveRecord::Base.connection.execute(sql_query)

    result.each do |row|
      house = row[0]
      work_hours = row[1]
      puts "House: #{house}, Work Hours: #{work_hours.to_i}"
    end
  end
end