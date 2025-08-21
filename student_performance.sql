CREATE DATABASE IF NOT EXISTS student_performance;
USE student_performance;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    intake_year INT NOT NULL
);

CREATE TABLE linux_grades (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE python_grades (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    student_id INT,
    grade_obtained DECIMAL(5,2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, student_name, intake_year) VALUES
(1, 'Alice Umutoni', 2024),
(2, 'Brian Niyonsenga', 2024),
(3, 'Cynthia Uwase', 2024),
(4, 'David Iradukunda', 2024),
(5, 'Emma Ingabire', 2023),
(6, 'Frank Habimana', 2023),
(7, 'Grace Mukamana', 2023),
(8, 'Henry Mugisha', 2024),
(9, 'Isabelle Uwimana', 2023),
(10, 'James Nkurunziza', 2023),
(11, 'Kevin Ndoli', 2024),
(12, 'Laura Imanishimwe', 2024),
(13, 'Michael Karera', 2023),
(14, 'Nadia Uwera', 2023),
(15, 'Patrick Habyarimana', 2024);

INSERT INTO linux_grades (course_id, course_name, student_id, grade_obtained) VALUES
(101, 'Linux', 1, 78.5),
(102, 'Linux', 2, 45.0),
(103, 'Linux', 3, 82.0),
(104, 'Linux', 4, 67.0),
(105, 'Linux', 5, 90.5),
(106, 'Linux', 6, 40.0),
(107, 'Linux', 7, 55.5),
(108, 'Linux', 8, 72.0),
(109, 'Linux', 9, 48.0),
(110, 'Linux', 10, 61.0);

INSERT INTO python_grades (course_id, course_name, student_id, grade_obtained) VALUES
(201, 'Python', 3, 88.0),
(202, 'Python', 4, 70.5),
(203, 'Python', 5, 92.0),
(204, 'Python', 6, 51.0),
(205, 'Python', 8, 69.0),
(206, 'Python', 10, 77.0),
(207, 'Python', 11, 85.0),
(208, 'Python', 12, 62.0),
(209, 'Python', 13, 54.0),
(210, 'Python', 14, 49.5),
(211, 'Python', 15, 73.0);

SELECT s.student_id, s.student_name, l.grade_obtained
FROM students s
JOIN linux_grades l ON s.student_id = l.student_id
WHERE l.grade_obtained < 50;

SELECT s.student_id, s.student_name
FROM students s
WHERE s.student_id IN (
    SELECT student_id FROM linux_grades
    UNION
    SELECT student_id FROM python_grades
)
AND s.student_id NOT IN (
    SELECT student_id
    FROM linux_grades
    INNER JOIN python_grades ON linux_grades.student_id = python_grades.student_id
);

SELECT DISTINCT s.student_id, s.student_name
FROM students s
JOIN linux_grades l ON s.student_id = l.student_id
JOIN python_grades p ON s.student_id = p.student_id;

SELECT 'Linux' AS course_name, AVG(grade_obtained) AS average_grade
FROM linux_grades
UNION
SELECT 'Python' AS course_name, AVG(grade_obtained) AS average_grade
FROM python_grades;

SELECT s.student_id, s.student_name,
       AVG(g.grade) AS overall_average
FROM students s
JOIN (
    SELECT student_id, grade_obtained AS grade FROM linux_grades
    UNION ALL
    SELECT student_id, grade_obtained AS grade FROM python_grades
) g ON s.student_id = g.student_id
GROUP BY s.student_id, s.student_name
ORDER BY overall_average DESC
LIMIT 1;
