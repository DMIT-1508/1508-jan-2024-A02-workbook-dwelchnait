use IQSchool

--Update

--Purpose
-- Allow the user to change one or more columns
--		on one or more records for a particular table

-- increase the number of student allowed in DMIT2015 to 20

UPDATE Course
SET MaxStudents = 20
WHERE CourseId = 'DMIT2015'

--due to COLA all fees for the couses must increase by 8%
UPDATE Course
SET CourseCost = CourseCost * 1.08

UPDATE Staff
SET FirstName = 'Charity',
    LastName = 'Kase'
WHERE StaffID = 8


UPDATE Staff
SET PositionID = (SELECT PositionID from Position	
					WHERE PositionDescription = 'Assistant Dean')
WHERE StaffID = 8