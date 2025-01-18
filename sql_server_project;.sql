CREATE DATABASE StudentRecordsDB;
GO
USE StudentRecordsDB;
GO

-- Create the Students table with the following columns:
-- student_id: unique identifier, auto-incremented
-- name: name of the student, cannot be null
-- email: optional email field for the student
-- phone_number: optional contact number for the student
-- enrollment_date: date when the student enrolled, defaults to the current date
CREATE TABLE Students (
    student_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255),
    phone_number NVARCHAR(15),
    enrollment_date DATE DEFAULT GETDATE()
);
GO

-- Create the Teachers table with the following columns:
-- teacher_id: unique identifier, auto-incremented
-- name: name of the teacher, cannot be null
-- email: optional email field for the teacher
-- hire_date: date the teacher was hired, defaults to the current date
CREATE TABLE Teachers (
    teacher_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255),
    hire_date DATE DEFAULT GETDATE()
);
GO

-- Create the Courses table with the following columns:
-- course_id: unique identifier for each course, auto-incremented
-- course_name: name of the course, cannot be null
-- teacher_id: references the teacher who teaches the course, foreign key from Teachers table
CREATE TABLE Courses (
    course_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    course_name NVARCHAR(255) NOT NULL,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id)
);
GO

-- Create the Enrollments table to track student enrollment in courses:
-- enrollment_id: unique identifier, auto-incremented
-- student_id: foreign key referencing the Students table
-- course_id: foreign key referencing the Courses table
-- enrollment_date: date when the student enrolled in the course, defaults to current date
CREATE TABLE Enrollments (
    enrollment_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT GETDATE(),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
GO

-- Create the Grades table to store the grades students receive in courses:
-- grade_id: unique identifier, auto-incremented
-- student_id: foreign key referencing the Students table
-- course_id: foreign key referencing the Courses table
-- grade: letter grade assigned to the student in the course
CREATE TABLE Grades (
    grade_id INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade CHAR(2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
GO

-- Insert student records into the Students table
INSERT INTO Students (name, email, phone_number) VALUES
('Liam Gentry', 'lima@example.com', '1234567890'),
('Lyric Glass', 'lyric@example.com', '0987654321');
GO

-- Insert teacher records into the Teachers table
INSERT INTO Teachers (name, email) VALUES
('Aiden Nichols', 'alice@example.com'),
('Beau Booth', 'beau@example.com');
GO

-- Insert course records into the Courses table, associating each course with a teacher
INSERT INTO Courses (course_name, teacher_id) VALUES
('Mathematics', 1),
('Physics', 2);
GO

-- Insert enrollment records for students into courses
INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 1), -- Student 1 enrolls in Course 1
(2, 2); -- Student 2 enrolls in Course 2
GO

-- Insert grade records for students in their respective courses
INSERT INTO Grades (student_id, course_id, grade) VALUES
(1, 1, 'A'), -- Student 1 gets grade 'A' in Course 1
(2, 2, 'B'); -- Student 2 gets grade 'B' in Course 2
GO

-- Insert a new student record into the Students table with name, email, and phone number
INSERT INTO Students (name, email, phone_number) VALUES
('Julio Stokes', 'julio@example.com', '0987654321');
GO

-- Insert a new enrollment record into the Enrollments table
INSERT INTO Enrollments (student_id, course_id) VALUES
(1, 2);
GO

-- Insert a new grade record into the Grades table
INSERT INTO Grades (student_id, course_id, grade) VALUES
(1, 2, 'A');
GO

-- Select student names and course name for students enrolled in course 1
SELECT s.name, c.course_name
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_id = 1;
GO

-- Select student name, course name, and grade for student 1
SELECT s.name, c.course_name, g.grade
FROM Grades g
JOIN Students s ON g.student_id = s.student_id
JOIN Courses c ON g.course_id = c.course_id
WHERE s.student_id = 1;
GO

-- Update the phone number of the student with student_id 1
UPDATE Students
SET phone_number = '9876543210'
WHERE student_id = 1;
GO

-- Delete the enrollment record for student 1 in course 2
DELETE FROM Enrollments
WHERE student_id = 1 AND course_id = 2;
GO

-- Select the names of courses taught by the teacher with teacher_id 2
SELECT course_name
FROM Courses
WHERE teacher_id = 2;
GO

-- Count the total number of students enrolled in course 1
SELECT COUNT(*) AS total_students
FROM Enrollments
WHERE course_id = 1;
GO

-- Select the names of students who do not have a grade for course 2
SELECT s.name
FROM Students s
LEFT JOIN Grades g ON s.student_id = g.student_id AND g.course_id = 2
WHERE g.grade IS NULL;
GO

-- Find the average grade for course 1 (assuming grades are stored as characters, e.g., 'A' = 4, 'B' = 3, etc.).
SELECT AVG(
    CASE 
        WHEN grade = 'A' THEN 4
        WHEN grade = 'B' THEN 3
        WHEN grade = 'C' THEN 2
        WHEN grade = 'D' THEN 1
        ELSE 0
    END) AS avg_grade
FROM Grades
WHERE course_id = 1;
GO

-- Retrieve the highest grade for students enrolled in course 2
SELECT MAX(grade) AS highest_grade
FROM Grades
WHERE course_id = 2;
GO

-- Insert a new course record into the Courses table
INSERT INTO Courses (course_name, teacher_id)
VALUES ('Chemistry', 3);
GO

-- Retrieve student names along with the count of courses they are enrolled in
SELECT s.name, COUNT(e.course_id) AS total_courses
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
GROUP BY s.name;
GO

-- Retrieve the names of courses that student with ID 1 is enrolled in
SELECT c.course_name
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
WHERE e.student_id = 1;
GO

-- Delete the course with course_id = 2 from the Courses table
DELETE FROM Courses WHERE course_id = 2;
GO

-- Delete all enrollments associated with the course_id = 2 from the Enrollments table
DELETE FROM Enrollments WHERE course_id = 2;
GO

-- Delete all grades associated with the course_id = 2 from the Grades table
DELETE FROM Grades WHERE course_id = 2;
GO
