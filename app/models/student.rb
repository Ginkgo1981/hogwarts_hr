class Student < ApplicationRecord
    # enum house: { gryffindor: 0, slytherin: 1, ravenclaw: 2,  hufflepuff: 3 }

    has_many :student_tasks
    has_many :tasks, through: :student_tasks
end
