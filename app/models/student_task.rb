class StudentTask < ApplicationRecord
    belongs_to :student, primary_key: :uuid, foreign_key: :student_uuid
end
