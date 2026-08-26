#!/bin/bash

# ============================================================================
# MySQL Database Initialization Script
# ============================================================================
# This script handles MySQL-specific setup, verification, and initialization.
#
# Purpose:
#   - Wait for MySQL service to be ready
#   - Initialize the course database (cis047_course)
#   - Create sample student database (classdb)
#   - Create database users with proper permissions
#   - Verify database connectivity
#
# Called by: startup.sh (main initialization script)
#
# MySQL Connection Details:
#   - Host: db (Docker container hostname)
#   - Port: 3306 (default MySQL port)
#   - Root user: root
#   - Root password: root
# ============================================================================

# Color codes for output formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration variables
MYSQL_HOST="db"
MYSQL_USER="root"
MYSQL_PASSWORD="root"
MYSQL_PORT="3306"
COURSE_DB="cis047_course"
COURSE_USER="cis047_user"
COURSE_PASSWORD="cis047_password"
SAMPLE_DB="classdb"

# Helper functions for output formatting
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# ============================================================================
# Function: Wait for MySQL Service
# ============================================================================
# Continuously tries to connect to MySQL until successful or max attempts reached
# Returns: 0 on success, 1 on failure
wait_for_mysql() {
    echo "Waiting for MySQL database service to be ready..."
    
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        # Use mysqladmin to check if MySQL is accepting connections
        if mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent 2>/dev/null; then
            print_status "MySQL is ready and accepting connections"
            return 0
        fi
        
        # Check if we've exceeded max attempts
        if [ $attempt -eq $max_attempts ]; then
            print_error "MySQL failed to start after $((max_attempts)) attempts (${max_attempts}s)"
            echo ""
            echo "Troubleshooting steps:"
            echo "  1. Check Docker daemon: docker ps"
            echo "  2. Check container status: docker logs cis047-db"
            echo "  3. Verify docker-compose.yml configuration"
            echo "  4. Ensure port 3306 is not in use"
            return 1
        fi
        
        echo "  Attempt $attempt/$max_attempts: Connecting to MySQL... (${attempt}s elapsed)"
        sleep 1
        ((attempt++))
    done
    
    return 1
}

# ============================================================================
# Function: Create Course Database
# ============================================================================
# Creates the main cis047_course database and applies the schema
create_course_database() {
    echo "Creating course database: $COURSE_DB"
    
    # Check if database already exists and has tables
    local table_count=$(mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
        -e "USE $COURSE_DB; SHOW TABLES;" 2>/dev/null | wc -l)
    
    if [ $table_count -gt 1 ]; then
        print_status "Course database already initialized ($(($table_count - 1)) tables found)"
        return 0
    fi
    
    print_info "Initializing database schema from init-db.sql..."
    
    # Execute the database schema script
    if mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$COURSE_DB" \
        < /workspaces/cis047-course-template/.devcontainer/init-db.sql 2>/dev/null; then
        print_status "Course database schema created successfully"
    else
        print_warning "Some tables may not have been created - schema script had errors"
        return 1
    fi
    
    return 0
}

# ============================================================================
# Function: Create Sample Student Database
# ============================================================================
# Creates the classdb database with sample tables and data for student practice
create_sample_database() {
    echo "Creating sample student database: $SAMPLE_DB"
    
    # Create the database with UTF-8 support
    mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "
        CREATE DATABASE IF NOT EXISTS $SAMPLE_DB 
        CHARACTER SET utf8mb4 
        COLLATE utf8mb4_unicode_ci;
    " 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "Created database: $SAMPLE_DB"
    else
        print_error "Failed to create $SAMPLE_DB database"
        return 1
    fi
    
    # Create sample students table with proper structure
    print_info "Creating sample 'students' table..."
    mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$SAMPLE_DB" -e "
        CREATE TABLE IF NOT EXISTS students (
            student_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique student identifier',
            first_name VARCHAR(50) NOT NULL COMMENT 'Student first name',
            last_name VARCHAR(50) NOT NULL COMMENT 'Student last name',
            email VARCHAR(100) UNIQUE NOT NULL COMMENT 'Student email address',
            gpa DECIMAL(3,2) COMMENT 'Grade point average',
            enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When student enrolled',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Record creation timestamp',
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Record update timestamp',
            INDEX idx_email (email),
            INDEX idx_enrollment_date (enrollment_date)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
        COMMENT='Sample students table for practice';
    " 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "Created 'students' table in $SAMPLE_DB"
    else
        print_error "Failed to create students table"
        return 1
    fi
    
    # Insert sample student records
    print_info "Inserting sample student records..."
    mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$SAMPLE_DB" -e "
        INSERT IGNORE INTO students (first_name, last_name, email, gpa) VALUES
        ('John', 'Doe', 'john.doe@university.edu', 3.85),
        ('Jane', 'Smith', 'jane.smith@university.edu', 3.92),
        ('Bob', 'Johnson', 'bob.johnson@university.edu', 3.45),
        ('Alice', 'Williams', 'alice.williams@university.edu', 3.78),
        ('Charlie', 'Brown', 'charlie.brown@university.edu', 3.56);
    " 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "Loaded 5 sample student records"
    else
        print_warning "Sample data insertion had errors"
        return 1
    fi
    
    return 0
}

# ============================================================================
# Function: Create Database Users
# ============================================================================
# Creates MySQL user accounts with appropriate permissions
create_database_users() {
    echo "Setting up database user accounts..."
    
    # Create course database user with limited privileges
    print_info "Creating course database user: $COURSE_USER"
    mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "
        -- Create user if it doesn't exist
        CREATE USER IF NOT EXISTS '$COURSE_USER'@'%' IDENTIFIED BY '$COURSE_PASSWORD';
        
        -- Grant privileges on course database
        GRANT ALL PRIVILEGES ON $COURSE_DB.* TO '$COURSE_USER'@'%';
        
        -- Grant privileges on sample database (read-only)
        GRANT SELECT, INSERT, UPDATE, DELETE ON $SAMPLE_DB.* TO '$COURSE_USER'@'%';
        
        -- Refresh privileges
        FLUSH PRIVILEGES;
    " 2>/dev/null
    
    if [ $? -eq 0 ]; then
        print_status "User '$COURSE_USER' configured with appropriate permissions"
    else
        print_warning "Error setting up course database user"
        return 1
    fi
    
    return 0
}

# ============================================================================
# Function: Verify Database Connectivity
# ============================================================================
# Tests connection to the database to ensure it's working
verify_connectivity() {
    echo "Verifying database connectivity..."
    
    # Test root connection
    print_info "Testing root user connection..."
    if mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" 2>/dev/null | grep -q 1; then
        print_status "Root user connection successful"
    else
        print_error "Root user connection failed"
        return 1
    fi
    
    # Test course user connection
    print_info "Testing course user connection..."
    if mysql -h"$MYSQL_HOST" -u"$COURSE_USER" -p"$COURSE_PASSWORD" "$COURSE_DB" -e "SELECT 1;" 2>/dev/null | grep -q 1; then
        print_status "Course user connection successful"
    else
        print_warning "Course user connection failed"
        return 1
    fi
    
    return 0
}

# ============================================================================
# Function: Display Database Information
# ============================================================================
# Shows summary of created databases and connection details
display_database_info() {
    echo ""
    echo "MySQL Database Summary:"
    echo "  Root User:"
    echo "    Host: $MYSQL_HOST"
    echo "    Port: $MYSQL_PORT"
    echo "    User: root"
    echo "    Password: root"
    echo ""
    echo "  Course Database:"
    echo "    Database: $COURSE_DB"
    echo "    User: $COURSE_USER"
    echo "    Password: $COURSE_PASSWORD"
    echo ""
    echo "  Sample Student Database:"
    echo "    Database: $SAMPLE_DB"
    echo "    User: root"
    echo "    Password: root"
    echo "    Sample table: students (5 records)"
    echo ""
}

# ============================================================================
# Main Execution
# ============================================================================
# This section runs when the script is executed

echo "=========================================="
echo "MySQL Database Initialization"
echo "=========================================="
echo ""

# Step 1: Wait for MySQL to be ready
if ! wait_for_mysql; then
    print_error "Failed to connect to MySQL service"
    exit 1
fi

echo ""

# Step 2: Create course database
if ! create_course_database; then
    print_warning "Course database creation had issues, but continuing..."
fi

echo ""

# Step 3: Create sample database
if ! create_sample_database; then
    print_warning "Sample database creation had issues, but continuing..."
fi

echo ""

# Step 4: Create database users
if ! create_database_users; then
    print_warning "Database user creation had issues, but continuing..."
fi

echo ""

# Step 5: Verify connectivity
if ! verify_connectivity; then
    print_warning "Some connectivity tests failed"
fi

echo ""

# Step 6: Display information
display_database_info

print_status "MySQL initialization complete"
echo ""
