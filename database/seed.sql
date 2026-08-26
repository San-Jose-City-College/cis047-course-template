-- Seed data for CIS 047 Course Database

-- Insert sample courses
INSERT INTO courses (course_code, course_name, description, credits) VALUES
('CIS047', 'Web Development Fundamentals', 'Introduction to HTML, CSS, JavaScript, PHP, and MySQL', 3),
('CIS050', 'Database Design', 'Relational database design and SQL', 3),
('CIS100', 'Programming Fundamentals', 'Introduction to programming concepts', 3);

-- Insert sample students
INSERT INTO students (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '555-0001'),
('Jane', 'Smith', 'jane.smith@example.com', '555-0002'),
('Bob', 'Johnson', 'bob.johnson@example.com', '555-0003'),
('Alice', 'Williams', 'alice.williams@example.com', '555-0004');

-- Insert sample enrollments
INSERT INTO enrollments (student_id, course_id) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1);
