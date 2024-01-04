class CreateShifts < ActiveRecord::Migration[6.1]
  def change
    create_table :shifts do |t|
      t.string :uuid
      t.datetime :start_time
      t.datetime :end_time
      t.integer :unpaid_break_minutes, default: 0
      t.integer :billable_rate, default: 0
      t.string :appointed_by # student uuid

      # t.timestamps
    end

    add_index :shifts, :uuid, unique: true
    add_index :shifts, :appointed_by
  end
end
