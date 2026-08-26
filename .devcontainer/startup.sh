#!/bin/bash

# ============================================================================
# CIS 047 Course Template - Main Startup Script
# ============================================================================
# This script runs automatically when the Codespace starts and orchestrates
# the initialization of all development environment components.
#
# Purpose:
#   - Waits for MySQL database to be ready
#   - Initializes the course database (cis047_course)
#   - Creates the sample student database (classdb)
#   - Verifies Apache configuration
#   - Displays environment information
#
# Exit behavior: Exits on any error (set -e)
# ============================================================================

set -e

# Color codes for output formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

# Print success message
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

# Print warning message
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Print error message
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Print info message
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Print section header
print_header() {
    echo ""
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

# ============================================================================
# STEP 1: Display startup banner
# ============================================================================

clear
print_header "CIS 047 Course Template - Environment Initialization"
echo ""
echo "Starting development environment setup..."
echo "This process will:"
echo "  • Wait for MySQL database to be ready"
echo "  • Initialize course database and tables"
echo "  • Create sample student database (classdb)"
echo "  • Verify Apache configuration"
echo "  • Display connection information"
echo ""

# ============================================================================
# STEP 2: Wait for MySQL to be ready
# ============================================================================

print_header "Step 1: Waiting for MySQL Database"

max_attempts=30
attempt=1
mysql_ready=false

echo "Attempting to connect to MySQL on host: db:3306"
echo ""

while [ $attempt -le $max_attempts ]; do
    if mysqladmin ping -h"db" -u"root" -p"root" --silent 2>/dev/null; then
        print_status "MySQL is ready and accepting connections"
        mysql_ready=true
        break
    fi
    
    if [ $attempt -eq $max_attempts ]; then
        print_error "MySQL failed to start after $((max_attempts * 1)) seconds"
        echo "Troubleshooting:"
        echo "  • Check that Docker containers are running"
        echo "  • Run: docker ps to see container status"
        echo "  • Run: docker logs cis047-db to see MySQL logs"
        exit 1
    fi
    
    echo "  Attempt $attempt/$max_attempts: Waiting for database... (${attempt}s)"
    sleep 1
    ((attempt++))
done

echo ""

# ============================================================================
# STEP 3: Initialize course database (cis047_course)
# ============================================================================

print_header "Step 2: Initializing Course Database"

# Check if tables already exist
TABLES=$(mysql -h"db" -u"root" -p"root" -e "USE cis047_course; SHOW TABLES;" 2>/dev/null | wc -l)

if [ $TABLES -le 1 ]; then
    print_info "Creating database schema from init-db.sql..."
    
    # Execute the database schema script
    if mysql -h"db" -u"root" -p"root" cis047_course < /workspaces/cis047-course-template/.devcontainer/init-db.sql 2>/dev/null; then
        print_status "Course database schema created successfully"
    else
        print_warning "Some tables may not have been created properly"
    fi
    
    print_info "Seeding database with sample data..."
    
    # Execute the seed data script (if it exists)
    if [ -f /workspaces/cis047-course-template/database/seed.sql ]; then
        mysql -h"db" -u"root" -p"root" cis047_course < /workspaces/cis047-course-template/database/seed.sql 2>/dev/null || true
        print_status "Sample data loaded into course database"
    else
        print_warning "No seed.sql file found - skipping sample data"
    fi
else
    print_status "Course database schema already initialized ($(($TABLES - 1)) tables found)"
fi

echo ""

# ============================================================================
# STEP 4: Create sample student database (classdb)
# ============================================================================

print_header "Step 3: Creating Sample Student Database"

print_info "Creating 'classdb' database for student assignments..."

# Create the classdb database with UTF-8 support
mysql -h"db" -u"root" -p"root" -e "
    CREATE DATABASE IF NOT EXISTS classdb 
    CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;
" 2>/dev/null

print_status "Created database: classdb"

print_info "Creating sample 'students' table in classdb..."

# Create a sample students table in classdb for demonstration
mysql -h"db" -u"root" -p"root" classdb -e "
    CREATE TABLE IF NOT EXISTS students (
        student_id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        gpa DECIMAL(3,2),
        enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_email (email)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
" 2>/dev/null

print_status "Created 'students' table in classdb"

print_info "Inserting sample student records..."

# Insert sample data into the students table
mysql -h"db" -u"root" -p"root" classdb -e "
    INSERT IGNORE INTO students (first_name, last_name, email, gpa) VALUES
    ('John', 'Doe', 'john.doe@university.edu', 3.85),
    ('Jane', 'Smith', 'jane.smith@university.edu', 3.92),
    ('Bob', 'Johnson', 'bob.johnson@university.edu', 3.45),
    ('Alice', 'Williams', 'alice.williams@university.edu', 3.78),
    ('Charlie', 'Brown', 'charlie.brown@university.edu', 3.56);
" 2>/dev/null

print_status "Loaded sample student records"

echo ""

# ============================================================================
# STEP 5: Set file permissions
# ============================================================================

print_header "Step 4: Setting File Permissions"

chmod -R 755 /workspaces/cis047-course-template/public 2>/dev/null || true
chmod -R 755 /workspaces/cis047-course-template/database 2>/dev/null || true
chmod +x /workspaces/cis047-course-template/.devcontainer/*.sh 2>/dev/null || true

print_status "File permissions configured"

echo ""

# ============================================================================
# STEP 6: Verify Apache configuration
# ============================================================================

print_header "Step 5: Verifying Apache Web Server"

if apache2ctl configtest > /dev/null 2>&1; then
    print_status "Apache configuration is valid"
else
    print_warning "Apache configuration test returned warnings"
fi

# Enable necessary Apache modules
print_info "Enabling Apache modules..."
a2enmod rewrite > /dev/null 2>&1 && print_status "mod_rewrite enabled" || print_warning "mod_rewrite may already be enabled"
a2enmod headers > /dev/null 2>&1 && print_status "mod_headers enabled" || print_warning "mod_headers may already be enabled"

echo ""

# ============================================================================
# STEP 7: Verify development tools
# ============================================================================

print_header "Step 6: Verifying Development Tools"

# Check PHP
if command -v php &> /dev/null; then
    PHP_VERSION=$(php -v | head -1 | awk '{print $2}')
    print_status "PHP installed (version $PHP_VERSION)"
else
    print_warning "PHP not found"
fi

# Check Composer
if command -v composer &> /dev/null; then
    print_status "Composer installed and available"
else
    print_warning "Composer not found in PATH"
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    print_status "Git installed (version $GIT_VERSION)"
else
    print_warning "Git not found"
fi

# Check MySQL client
if command -v mysql &> /dev/null; then
    print_status "MySQL client installed"
else
    print_warning "MySQL client not found"
fi

echo ""

# ============================================================================
# STEP 8: Display connection information
# ============================================================================

print_header "Environment Ready!"

echo ""
echo "🌐 Web Application:"
echo "   URL: http://localhost"
echo "   HTTPS: https://localhost"
echo "   Document Root: /workspaces/cis047-course-template/public"
echo ""

echo "🗄️  MySQL Database Connections:"
echo ""
echo "   Couse Database (cis047_course):"
echo "      Host: db"
echo "      Port: 3306"
echo "      Database: cis047_course"
echo "      User: cis047_user"
echo "      Password: cis047_password"
echo ""
echo "   Sample Student Database (classdb):"
echo "      Host: db"
echo "      Port: 3306"
echo "      Database: classdb"
echo "      User: root"
echo "      Password: root"
echo ""
echo "   Admin Connection (all databases):"
echo "      Host: db"
echo "      Port: 3306"
echo "      User: root"
echo "      Password: root"
echo ""

echo "💻 Development Servers:"
echo "   Node.js: Port 3000 (available for use)"
echo "   Apache HTTP: Port 80"
echo "   Apache HTTPS: Port 443"
echo ""

echo "📦 Pre-installed VS Code Extensions:"
echo "   • Live Server"
echo "   • PHP Intellisense & Debug"
echo "   • MySQL Client"
echo "   • Prettier (Code Formatter)"
echo "   • ESLint (JavaScript Linter)"
echo "   • Auto Close/Rename Tags"
echo ""

echo "📚 Project Structure:"
echo "   • lessons/          - Course materials"
echo "   • examples/         - Reference code samples"
echo "   • assignments/      - Student assignments"
echo "   • public/           - Web-accessible files (Apache root)"
echo "   • database/         - Database schemas and configs"
echo ""

echo "🚀 Next Steps:"
echo "   1. Open http://localhost in your browser"
echo "   2. Navigate to the lessons/ folder"
echo "   3. Review examples/ for reference code"
echo "   4. Start working on assignments/"
echo ""

echo "📖 Using the Sample Database:"
echo "   • Database: classdb"
echo "   • Connect with: mysql -h db -u root -p classdb"
echo "   • Tables: students (with sample data)"
echo "   • Use this for your MySQL assignments and practice"
echo ""

echo "=========================================="
echo "✓ Setup Complete - Happy Coding!"
echo "=========================================="
echo ""

# ============================================================================
# STEP 9: Ensure Apache is running
# ============================================================================

# Check if Apache is already running
if pgrep -x "apache2" > /dev/null; then
    print_status "Apache is running"
else
    print_info "Starting Apache web server..."
    apache2ctl start > /dev/null 2>&1 || true
    sleep 2
    
    if pgrep -x "apache2" > /dev/null; then
        print_status "Apache started successfully"
    else
        print_warning "Apache may not have started properly"
    fi
fi

echo ""
print_status "Environment initialization complete!"
echo ""
