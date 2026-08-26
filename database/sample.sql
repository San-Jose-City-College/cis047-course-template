-- ============================================================================
-- CIS 047 - Intro to Web Development
-- Sample Database Schema and Data
-- ============================================================================
-- 
-- Database: cis047_course
-- Purpose: Educational database for students to practice SQL queries
-- 
-- This file creates sample tables and populates them with diverse, 
-- culturally appropriate data relevant to the San Jose, California area.
-- 
-- Tables:
--   1. students  - Student enrollment records
--   2. products  - Product inventory for sample e-commerce scenarios
--
-- Created: 2026
-- Last Updated: 2026
--
-- ============================================================================

-- ============================================================================
-- DATABASE SETUP
-- ============================================================================

-- Use the cis047_course database
USE cis047_course;

-- ============================================================================
-- TABLE 1: STUDENTS
-- ============================================================================
-- Stores student enrollment information with diverse, culturally appropriate
-- names reflecting the San Jose area demographics (Hispanic, Asian, and 
-- European heritage).
--
-- Columns:
--   student_id    - Unique identifier (auto-incremented)
--   first_name    - Student's first name
--   last_name     - Student's last name
--   email         - University email address
--   major         - Field of study
--   gpa           - Cumulative grade point average (0.0 to 4.0)
--   enrollment_date - Date student enrolled in the program
--   phone         - Contact phone number
--   created_at    - Record creation timestamp
--   updated_at    - Record last update timestamp
--
-- ============================================================================

DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique student identifier',
    first_name VARCHAR(50) NOT NULL COMMENT 'Student first name',
    last_name VARCHAR(50) NOT NULL COMMENT 'Student last name',
    email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Unique email address',
    major VARCHAR(100) NOT NULL COMMENT 'Field of study',
    gpa DECIMAL(3, 2) NOT NULL DEFAULT 3.5 COMMENT 'Cumulative GPA (0.0-4.0)',
    enrollment_date DATE NOT NULL COMMENT 'Date of enrollment',
    phone VARCHAR(20) COMMENT 'Contact phone number',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Record creation time',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record update time',
    INDEX idx_email (email),
    INDEX idx_major (major),
    INDEX idx_enrollment_date (enrollment_date)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci 
COMMENT = 'Student enrollment records for CIS 047 course';

-- ============================================================================
-- INSERT SAMPLE STUDENT DATA
-- ============================================================================
-- 10 diverse student records with culturally appropriate names representing
-- the San Jose area population (Hispanic, Asian, and European heritage).
--

INSERT INTO students 
    (first_name, last_name, email, major, gpa, enrollment_date, phone) 
VALUES
    (
        'Maria',
        'Gonzalez',
        'maria.gonzalez@university.edu',
        'Computer Science',
        3.85,
        '2025-01-15',
        '(408) 555-0101'
    ),
    (
        'Wei',
        'Chen',
        'wei.chen@university.edu',
        'Information Systems',
        3.92,
        '2025-01-15',
        '(408) 555-0102'
    ),
    (
        'James',
        'O''Brien',
        'james.obrien@university.edu',
        'Business Administration',
        3.45,
        '2025-01-16',
        '(408) 555-0103'
    ),
    (
        'Priya',
        'Patel',
        'priya.patel@university.edu',
        'Computer Science',
        3.78,
        '2025-01-16',
        '(408) 555-0104'
    ),
    (
        'Carlos',
        'Hernandez',
        'carlos.hernandez@university.edu',
        'Software Engineering',
        3.56,
        '2025-01-17',
        '(408) 555-0105'
    ),
    (
        'Lisa',
        'Anderson',
        'lisa.anderson@university.edu',
        'Information Systems',
        3.88,
        '2025-01-17',
        '(408) 555-0106'
    ),
    (
        'Jin',
        'Kim',
        'jin.kim@university.edu',
        'Business Administration',
        3.72,
        '2025-01-18',
        '(408) 555-0107'
    ),
    (
        'Sofia',
        'Rodriguez',
        'sofia.rodriguez@university.edu',
        'Data Science',
        3.91,
        '2025-01-18',
        '(408) 555-0108'
    ),
    (
        'Michael',
        'Murphy',
        'michael.murphy@university.edu',
        'Computer Science',
        3.64,
        '2025-01-19',
        '(408) 555-0109'
    ),
    (
        'Aisha',
        'Mahdi',
        'aisha.mahdi@university.edu',
        'Information Systems',
        3.79,
        '2025-01-19',
        '(408) 555-0110'
    );

-- ============================================================================
-- TABLE 2: PRODUCTS
-- ============================================================================
-- Product inventory for sample e-commerce or retail scenarios. Includes
-- generic, everyday products that students might encounter in real business
-- applications.
--
-- Columns:
--   product_id    - Unique product identifier (auto-incremented)
--   product_name  - Name of the product
--   category      - Product category for organization
--   price         - Unit price in USD
--   quantity_stock - Quantity currently in inventory
--   supplier      - Supplier or manufacturer name
--   description   - Brief product description
--   sku           - Stock Keeping Unit (unique product code)
--   created_at    - Date product was added to inventory
--   updated_at    - Date product information was last updated
--
-- ============================================================================

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique product identifier',
    product_name VARCHAR(150) NOT NULL COMMENT 'Name of the product',
    category VARCHAR(50) NOT NULL COMMENT 'Product category',
    price DECIMAL(10, 2) NOT NULL COMMENT 'Unit price in USD',
    quantity_stock INT NOT NULL DEFAULT 0 COMMENT 'Quantity in stock',
    supplier VARCHAR(100) NOT NULL COMMENT 'Supplier or manufacturer',
    description VARCHAR(255) COMMENT 'Product description',
    sku VARCHAR(50) UNIQUE NOT NULL COMMENT 'Stock Keeping Unit',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Date product added',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date product updated',
    INDEX idx_category (category),
    INDEX idx_price (price),
    INDEX idx_sku (sku),
    INDEX idx_supplier (supplier)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci 
COMMENT = 'Product inventory for retail or e-commerce scenarios';

-- ============================================================================
-- INSERT SAMPLE PRODUCT DATA
-- ============================================================================
-- 10 generic products with various categories, prices, and suppliers.
-- These represent common items students might encounter in real business data.
--

INSERT INTO products 
    (product_name, category, price, quantity_stock, supplier, description, sku) 
VALUES
    (
        'Wireless Mouse',
        'Electronics',
        24.99,
        145,
        'TechGear Solutions',
        'Ergonomic wireless mouse with 2.4GHz USB receiver',
        'SKU-ELC-001'
    ),
    (
        'USB-C Charging Cable',
        'Electronics',
        12.49,
        320,
        'CableConnect Inc',
        '6-foot USB-C to USB-A charging and data cable',
        'SKU-ELC-002'
    ),
    (
        'Office Desk Lamp',
        'Office Supplies',
        45.00,
        87,
        'Luminous Designs',
        'LED desk lamp with adjustable brightness and color temperature',
        'SKU-OFF-001'
    ),
    (
        'Notebook Pack (100 sheets)',
        'Office Supplies',
        8.99,
        450,
        'PaperWorks Ltd',
        'College-ruled notebook with durable binding',
        'SKU-OFF-002'
    ),
    (
        'Mechanical Keyboard',
        'Electronics',
        89.99,
        67,
        'KeyMaster Tech',
        'RGB backlit mechanical keyboard for gaming and typing',
        'SKU-ELC-003'
    ),
    (
        'Desk Organizer Set',
        'Office Supplies',
        19.99,
        210,
        'HomeOrganize Pro',
        'Multi-compartment desk organizer with drawer and shelves',
        'SKU-OFF-003'
    ),
    (
        'Monitor Stand with Storage',
        'Furniture',
        79.95,
        42,
        'ErgoFurniture Co',
        'Adjustable monitor stand with built-in storage drawer',
        'SKU-FURN-001'
    ),
    (
        'Webcam HD 1080p',
        'Electronics',
        54.99,
        128,
        'VisionCamera Ltd',
        'USB webcam with crystal clear 1080p video and stereo microphone',
        'SKU-ELC-004'
    ),
    (
        'Coffee Mug (Ceramic)',
        'Drinkware',
        9.99,
        350,
        'CeramicCraft Industries',
        '12oz ceramic coffee mug with heat-resistant handle',
        'SKU-DRK-001'
    ),
    (
        'Document Folder Set',
        'Office Supplies',
        14.50,
        280,
        'FilePro Systems',
        'Set of 12 colorful file folders with labels',
        'SKU-OFF-004'
    );

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================
-- Uncomment these queries to verify the data was inserted correctly
--

-- SELECT COUNT(*) as total_students FROM students;
-- SELECT COUNT(*) as total_products FROM products;
-- SELECT * FROM students ORDER BY enrollment_date;
-- SELECT * FROM products ORDER BY category, product_name;

-- ============================================================================
-- END OF DATABASE SETUP
-- ============================================================================
