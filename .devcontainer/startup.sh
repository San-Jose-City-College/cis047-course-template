#!/bin/bash

# ============================================================================
# CIS 047 Course Template - Startup Script
# ============================================================================
# Waits for MySQL to be ready, then displays environment information.
# Database tables and sample data are loaded automatically by MySQL from
# database/sample.sql on first launch.
# ============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status()  { echo -e "${GREEN}✓${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_error()   { echo -e "${RED}✗${NC} $1"; }
print_info()    { echo -e "${BLUE}ℹ${NC} $1"; }

echo ""
echo "=========================================="
echo "  CIS 047 - Environment Initialization"
echo "=========================================="
echo ""

# ============================================================================
# Wait for MySQL
# ============================================================================

print_info "Waiting for MySQL database to be ready..."

max_attempts=60
attempt=1

while [ $attempt -le $max_attempts ]; do
    if mysqladmin ping -h"db" -u"root" -p"root" --silent 2>/dev/null; then
        print_status "MySQL is ready"
        break
    fi

    if [ $attempt -eq $max_attempts ]; then
        print_warning "MySQL was not ready after ${max_attempts}s. The database may still be starting."
        print_warning "Wait 30 seconds, then refresh the page. If the problem persists, reload the Codespace."
        break
    fi

    echo "  Waiting for MySQL... ($attempt/$max_attempts)"
    sleep 1
    ((attempt++))
done

echo ""

# ============================================================================
# Verify Apache
# ============================================================================

if pgrep -x "apache2" > /dev/null; then
    print_status "Apache web server is running"
else
    print_warning "Apache does not appear to be running"
fi

echo ""

# ============================================================================
# Display Connection Info
# ============================================================================

echo "=========================================="
echo "  Your Development Environment is Ready!"
echo "=========================================="
echo ""
echo "  Web Server:  Open port 80 in the Ports panel"
echo "  Database:"
echo "    Host:      db"
echo "    Database:  classdb"
echo "    User:      cis047_user"
echo "    Password:  cis047_password"
echo ""
echo "  Example pages (open port 80 first):"
echo "    /examples/database-connect.php"
echo "    /examples/display-students.php"
echo "    /examples/search-products.php"
echo "    /examples/add-customer.php"
echo ""
print_status "Ready! Open the Ports panel and click the port 80 link to view your site."
echo ""
