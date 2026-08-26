#!/bin/bash

# CIS 047 Course Template - Startup Script
# This script runs when the Codespace starts to initialize the development environment

set -e  # Exit on error

echo "=========================================="
echo "CIS 047 Course Template - Startup"
echo "=========================================="

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# 1. Wait for MariaDB to be ready
echo ""
echo "Waiting for MariaDB database to be ready..."
max_attempts=30
attempt=1

while [ $attempt -le $max_attempts ]; do
    if mysqladmin ping -h"db" -u"root" -p"root" --silent 2>/dev/null; then
        print_status "MariaDB is ready"
        break
    fi
    
    if [ $attempt -eq $max_attempts ]; then
        print_error "MariaDB failed to start after 30 seconds"
        exit 1
    fi
    
    echo "  Attempt $attempt/$max_attempts: Waiting for database..."
    sleep 1
    ((attempt++))
done

# 2. Initialize database schema if not already done
echo ""
echo "Checking database tables..."
TABLES=$(mysql -h"db" -u"root" -p"root" -e "USE cis047_course; SHOW TABLES;" 2>/dev/null | wc -l)

if [ $TABLES -le 1 ]; then
    print_status "Initializing database schema..."
    mysql -h"db" -u"root" -p"root" cis047_course < /workspaces/cis047-course-template/database/schema.sql 2>/dev/null || true
    
    print_status "Seeding database with sample data..."
    mysql -h"db" -u"root" -p"root" cis047_course < /workspaces/cis047-course-template/database/seed.sql 2>/dev/null || true
else
    print_status "Database schema already initialized"
fi

# 3. Set proper file permissions
echo ""
echo "Setting file permissions..."
chmod -R 755 /workspaces/cis047-course-template/public 2>/dev/null || true
chmod -R 755 /workspaces/cis047-course-template/database 2>/dev/null || true
print_status "File permissions set"

# 4. Verify Apache is running
echo ""
echo "Verifying Apache configuration..."
apache2ctl configtest > /dev/null 2>&1 && print_status "Apache configuration is valid" || print_warning "Apache configuration may need review"

# 5. Enable Apache modules if needed
echo ""
echo "Enabling Apache modules..."
a2enmod rewrite > /dev/null 2>&1 && print_status "mod_rewrite enabled" || print_warning "mod_rewrite already enabled"
a2enmod headers > /dev/null 2>&1 && print_status "mod_headers enabled" || print_warning "mod_headers already enabled"

# 6. Verify Composer is installed
echo ""
echo "Verifying development tools..."
if command -v composer &> /dev/null; then
    COMPOSER_VERSION=$(composer --version | awk '{print $3}')
    print_status "Composer is installed (version $COMPOSER_VERSION)"
else
    print_warning "Composer not found in PATH"
fi

# 7. Verify Git is installed
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    print_status "Git is installed (version $GIT_VERSION)"
else
    print_warning "Git not found"
fi

# 8. Verify PHP version
echo ""
echo "PHP Configuration:"
php -v | head -1

# 9. Display connection information
echo ""
echo "=========================================="
echo "Environment Ready!"
echo "=========================================="
echo ""
echo "Web Application:"
echo "  URL: http://localhost"
echo "  Document Root: /workspaces/cis047-course-template/public"
echo ""
echo "Database (MariaDB):"
echo "  Host: db"
echo "  Port: 3306"
echo "  Root User: root"
echo "  Root Password: root"
echo "  Database: cis047_course"
echo "  User: cis047_user"
echo "  Password: cis047_password"
echo ""
echo "Development Server:"
echo "  Port 3000 available for Node.js development"
echo ""
echo "VS Code Extensions:"
echo "  - Live Server"
echo "  - PHP Intellisense"
echo "  - MySQL Client"
echo "  - Prettier"
echo "  - ESLint"
echo "  - PHP Debug"
echo ""
echo "Next Steps:"
echo "  1. Open http://localhost in your browser"
echo "  2. Review lessons/ folder for course materials"
echo "  3. Check examples/ folder for reference code"
echo "  4. Start with assignments/ folder"
echo ""
echo "=========================================="
echo ""

# 9. Start Apache in the background (if not already running)
if ! pgrep -x "apache2" > /dev/null; then
    echo "Starting Apache web server..."
    apache2ctl start > /dev/null 2>&1 || true
    sleep 2
    print_status "Apache started successfully"
else
    print_status "Apache is already running"
fi

echo ""
print_status "Startup complete! Your development environment is ready."
echo ""
