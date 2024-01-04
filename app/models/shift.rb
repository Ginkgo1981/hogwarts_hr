class Shift < ApplicationRecord
    belongs_to :student, primary_key: :uuid, foreign_key: :appointed_by
end
