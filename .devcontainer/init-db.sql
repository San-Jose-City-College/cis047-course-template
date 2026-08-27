-- CIS 047 Course Database Initialization Script
-- Canonical initialization source for the Codespaces MySQL container.

CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    major VARCHAR(100),
    gpa DECIMAL(3,2),
    enrollment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_enrollment_date (enrollment_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Migration guards keep existing database volumes in sync with the canonical
-- students schema without failing when the columns already exist.
SET @add_phone = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'students' AND COLUMN_NAME = 'phone') = 0,
    'ALTER TABLE students ADD COLUMN phone VARCHAR(20)',
    'SELECT 1'
);
PREPARE stmt FROM @add_phone;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @add_major = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'students' AND COLUMN_NAME = 'major') = 0,
    'ALTER TABLE students ADD COLUMN major VARCHAR(100)',
    'SELECT 1'
);
PREPARE stmt FROM @add_major;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @add_gpa = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'students' AND COLUMN_NAME = 'gpa') = 0,
    'ALTER TABLE students ADD COLUMN gpa DECIMAL(3,2)',
    'SELECT 1'
);
PREPARE stmt FROM @add_gpa;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @add_enrollment_date = IF(
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'students' AND COLUMN_NAME = 'enrollment_date') = 0,
    'ALTER TABLE students ADD COLUMN enrollment_date DATE',
    'SELECT 1'
);
PREPARE stmt FROM @add_enrollment_date;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @normalize_enrollment_date = IF(
    IFNULL((SELECT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'students' AND COLUMN_NAME = 'enrollment_date' LIMIT 1), '') <> 'date',
    'ALTER TABLE students MODIFY COLUMN enrollment_date DATE',
    'SELECT 1'
);
PREPARE stmt FROM @normalize_enrollment_date;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

CREATE TABLE IF NOT EXISTS courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT DEFAULT 3,
    semester VARCHAR(50),
    instructor VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_course_code (course_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    grade VARCHAR(2),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completion_date DATETIME,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id),
    INDEX idx_student_id (student_id),
    INDEX idx_course_id (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    assignment_name VARCHAR(100) NOT NULL,
    description TEXT,
    due_date DATE,
    points INT DEFAULT 100,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_course_id (course_id),
    INDEX idx_due_date (due_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    grade INT,
    feedback TEXT,
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    UNIQUE KEY unique_submission (assignment_id, student_id),
    INDEX idx_student_id (student_id),
    INDEX idx_assignment_id (assignment_id),
    INDEX idx_submission_date (submission_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    resource_name VARCHAR(100) NOT NULL,
    resource_url VARCHAR(500),
    resource_type ENUM('lecture', 'video', 'reading', 'tool', 'documentation') DEFAULT 'reading',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_course_id (course_id),
    INDEX idx_resource_type (resource_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS activity_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    activity_type VARCHAR(50),
    activity_description TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id),
    INDEX idx_timestamp (timestamp)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity_stock INT NOT NULL DEFAULT 0,
    supplier VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    sku VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_price (price),
    INDEX idx_sku (sku)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_last_name (last_name),
    INDEX idx_city (city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO courses (course_code, course_name, description, credits, semester, instructor) VALUES
('CIS047', 'Web Development Fundamentals', 'Introduction to HTML, CSS, JavaScript, PHP, and MySQL', 3, 'Fall 2026', 'CIS 047 Staff'),
('CIS050', 'Database Design', 'Relational database design and SQL', 3, 'Fall 2026', 'CIS 047 Staff'),
('CIS100', 'Programming Fundamentals', 'Introduction to programming concepts', 3, 'Fall 2026', 'CIS 047 Staff');

INSERT IGNORE INTO students (first_name, last_name, email, phone, major, gpa, enrollment_date) VALUES
('Maria', 'Gonzalez', 'maria.gonzalez@university.edu', '(408) 555-0101', 'Computer Science', 3.85, '2025-01-15'),
('Wei', 'Chen', 'wei.chen@university.edu', '(408) 555-0102', 'Information Systems', 3.92, '2025-01-15'),
('James', 'O''Brien', 'james.obrien@university.edu', '(408) 555-0103', 'Business Administration', 3.45, '2025-01-16'),
('Priya', 'Patel', 'priya.patel@university.edu', '(408) 555-0104', 'Computer Science', 3.78, '2025-01-16'),
('Carlos', 'Hernandez', 'carlos.hernandez@university.edu', '(408) 555-0105', 'Software Engineering', 3.56, '2025-01-17');

INSERT IGNORE INTO products (product_name, category, price, quantity_stock, supplier, description, sku) VALUES
('Wireless Mouse', 'Electronics', 24.99, 145, 'TechGear Solutions', 'Ergonomic wireless mouse with 2.4GHz USB receiver', 'SKU-ELC-001'),
('USB-C Charging Cable', 'Electronics', 12.49, 320, 'CableConnect Inc', '6-foot USB-C to USB-A charging and data cable', 'SKU-ELC-002'),
('Office Desk Lamp', 'Office Supplies', 45.00, 87, 'Luminous Designs', 'LED desk lamp with adjustable brightness and color temperature', 'SKU-OFF-001'),
('Notebook Pack (100 sheets)', 'Office Supplies', 8.99, 450, 'PaperWorks Ltd', 'College-ruled notebook with durable binding', 'SKU-OFF-002'),
('Mechanical Keyboard', 'Electronics', 89.99, 67, 'KeyMaster Tech', 'RGB backlit mechanical keyboard for gaming and typing', 'SKU-ELC-003');

INSERT IGNORE INTO enrollments (student_id, course_id)
SELECT s.student_id, c.course_id
FROM students s
JOIN courses c ON c.course_code = 'CIS047'
WHERE s.email IN (
    'maria.gonzalez@university.edu',
    'wei.chen@university.edu',
    'james.obrien@university.edu',
    'priya.patel@university.edu'
);

CREATE USER IF NOT EXISTS 'cis047_user'@'%' IDENTIFIED BY 'cis047_password';
GRANT ALL PRIVILEGES ON cis047_course.* TO 'cis047_user'@'%';
FLUSH PRIVILEGES;

SHOW TABLES;
