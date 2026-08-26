#!/bin/bash

# ============================================================================
# MySQL Database Initialization Script
# ============================================================================
# Utility script for manually verifying the canonical CIS 047 MySQL setup.
#
# Purpose:
#   - Wait for MySQL service to be ready
#   - Apply the canonical database initialization from .devcontainer/init-db.sql
#   - Verify application and admin connectivity
#   - Display connection details
# ============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

MYSQL_HOST="db"
MYSQL_USER="root"
MYSQL_PASSWORD="root"
MYSQL_PORT="3306"
COURSE_DB="cis047_course"
COURSE_USER="cis047_user"
COURSE_PASSWORD="cis047_password"

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

wait_for_mysql() {
    echo "Waiting for MySQL database service to be ready..."

    local max_attempts=30
    local attempt=1

    while [ $attempt -le $max_attempts ]; do
        if MYSQL_PWD="$MYSQL_PASSWORD" mysqladmin ping -h"$MYSQL_HOST" -u"$MYSQL_USER" --silent > /dev/null 2>&1; then
            print_status "MySQL is ready and accepting connections"
            return 0
        fi

        if [ $attempt -eq $max_attempts ]; then
            print_error "MySQL failed to start after ${max_attempts}s"
            return 1
        fi

        echo "  Attempt $attempt/$max_attempts: Connecting to MySQL... (${attempt}s elapsed)"
        sleep 1
        ((attempt++))
    done

    return 1
}

apply_course_database() {
    echo "Applying course database initialization: $COURSE_DB"

    if MYSQL_PWD="$MYSQL_PASSWORD" mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" "$COURSE_DB" < /workspaces/cis047-course-template/.devcontainer/init-db.sql; then
        print_status "Course database schema and sample data verified"
        return 0
    fi

    print_warning "Course database initialization reported issues"
    return 1
}

verify_connectivity() {
    echo "Verifying database connectivity..."

    print_info "Testing root user connection..."
    if MYSQL_PWD="$MYSQL_PASSWORD" mysql -h"$MYSQL_HOST" -u"$MYSQL_USER" -e "SELECT 1;" 2>/dev/null | grep -q 1; then
        print_status "Root user connection successful"
    else
        print_error "Root user connection failed"
        return 1
    fi

    print_info "Testing application user connection..."
    if MYSQL_PWD="$COURSE_PASSWORD" mysql -h"$MYSQL_HOST" -u"$COURSE_USER" "$COURSE_DB" -e "SELECT 1;" 2>/dev/null | grep -q 1; then
        print_status "Application user connection successful"
    else
        print_warning "Application user connection failed"
        return 1
    fi

    return 0
}

display_database_info() {
    echo ""
    echo "MySQL Database Summary:"
    echo "  Application Database:"
    echo "    Host: $MYSQL_HOST"
    echo "    Port: $MYSQL_PORT"
    echo "    Database: $COURSE_DB"
    echo "    User: $COURSE_USER"
    echo "    Password: $COURSE_PASSWORD"
    echo ""
    echo "  Admin Connection (troubleshooting only):"
    echo "    Host: $MYSQL_HOST"
    echo "    Port: $MYSQL_PORT"
    echo "    User: root"
    echo "    Password: root"
    echo ""
}

echo "=========================================="
echo "MySQL Database Initialization"
echo "=========================================="
echo ""

if ! wait_for_mysql; then
    print_error "Failed to connect to MySQL service"
    exit 1
fi

echo ""
if ! apply_course_database; then
    print_warning "Course database initialization had issues, but continuing..."
fi

echo ""
if ! verify_connectivity; then
    print_warning "Some connectivity tests failed"
fi

echo ""
display_database_info

print_status "MySQL initialization complete"
echo ""
