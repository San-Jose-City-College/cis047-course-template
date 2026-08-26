#!/bin/bash

# ============================================================================
# CIS 047 Course Template - Main Startup Script
# ============================================================================
# This script runs automatically when the Codespace starts and verifies that
# the development environment is ready for student work.
#
# Purpose:
#   - Wait for MySQL database to be ready
#   - Apply the canonical database initialization from .devcontainer/init-db.sql
#   - Verify Apache configuration
#   - Display connection information
#
# Exit behavior: Exits on any error (set -e)
# ============================================================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

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

print_header() {
    echo ""
    echo "=========================================="
    echo "$1"
    echo "=========================================="
}

clear
print_header "CIS 047 Course Template - Environment Initialization"
echo ""
echo "Starting development environment setup..."
echo "This process will:"
echo "  • Wait for MySQL database to be ready"
echo "  • Apply the canonical course database setup"
echo "  • Verify Apache configuration"
echo "  • Display connection information"
echo ""

print_header "Step 1: Waiting for MySQL Database"

max_attempts=30
attempt=1

echo "Attempting to connect to MySQL on host: db:3306"
echo ""

while [ $attempt -le $max_attempts ]; do
    if MYSQL_PWD="root" mysqladmin ping -h"db" -u"root" --silent > /dev/null 2>&1; then
        print_status "MySQL is ready and accepting connections"
        break
    fi

    if [ $attempt -eq $max_attempts ]; then
        print_error "MySQL failed to start after $max_attempts seconds"
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
print_header "Step 2: Applying Course Database Initialization"
print_info "Running .devcontainer/init-db.sql against cis047_course..."

if MYSQL_PWD="root" mysql -h"db" -u"root" cis047_course < /workspaces/cis047-course-template/.devcontainer/init-db.sql; then
    print_status "Course database schema and sample data verified"
else
    print_warning "Database initialization reported issues"
fi

echo ""
print_header "Step 3: Setting File Permissions"
chmod -R 755 /workspaces/cis047-course-template/public 2>/dev/null || true
chmod -R 755 /workspaces/cis047-course-template/database 2>/dev/null || true
chmod +x /workspaces/cis047-course-template/.devcontainer/*.sh 2>/dev/null || true
print_status "File permissions configured"

echo ""
print_header "Step 4: Verifying Apache Web Server"
if apache2ctl configtest > /dev/null 2>&1; then
    print_status "Apache configuration is valid"
else
    print_warning "Apache configuration test returned warnings"
fi

print_info "Enabling Apache modules..."
a2enmod rewrite > /dev/null 2>&1 && print_status "mod_rewrite enabled" || print_warning "mod_rewrite may already be enabled"
a2enmod headers > /dev/null 2>&1 && print_status "mod_headers enabled" || print_warning "mod_headers may already be enabled"

echo ""
print_header "Step 5: Verifying Development Tools"

if command -v php &> /dev/null; then
    PHP_VERSION=$(php -v | head -1 | awk '{print $2}')
    print_status "PHP installed (version $PHP_VERSION)"
else
    print_warning "PHP not found"
fi

if command -v composer &> /dev/null; then
    print_status "Composer installed and available"
else
    print_warning "Composer not found in PATH"
fi

if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | awk '{print $3}')
    print_status "Git installed (version $GIT_VERSION)"
else
    print_warning "Git not found"
fi

if command -v mysql &> /dev/null; then
    print_status "MySQL client installed"
else
    print_warning "MySQL client not found"
fi

echo ""
print_header "Environment Ready!"
echo ""
echo "🌐 Web Application:"
echo "   URL: http://localhost"
echo "   HTTPS: https://localhost"
echo "   Document Root: /workspaces/cis047-course-template/public"
echo ""
echo "🗄️  MySQL Database Connections:"
echo ""
echo "   Application Database:"
echo "      Host: db"
echo "      Port: 3306"
echo "      Database: cis047_course"
echo "      User: cis047_user"
echo "      Password: cis047_password"
echo "      Tables: students, products, customers, and course support tables"
echo ""
echo "   Admin Connection (troubleshooting only):"
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
echo "📚 Project Structure:"
echo "   • lessons/          - Course materials"
echo "   • examples/         - Reference code samples"
echo "   • assignments/      - Student assignments"
echo "   • public/           - Web-accessible files (Apache root)"
echo "   • database/         - Reference schemas and configs"
echo ""
echo "🚀 Next Steps:"
echo "   1. Open http://localhost in your browser"
echo "   2. Navigate to the lessons/ folder"
echo "   3. Review examples/ for reference code"
echo "   4. Start working on assignments/"
echo ""
echo "📖 Using the Course Database:"
echo "   • Database: cis047_course"
echo "   • Connect with: mysql -h db -u cis047_user -pcis047_password cis047_course"
echo "   • Tables: students, products, customers"
echo "   • Root/root is reserved for admin troubleshooting"
echo ""
echo "=========================================="
echo "✓ Setup Complete - Happy Coding!"
echo "=========================================="
echo ""

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
