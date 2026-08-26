#!/bin/bash

# ============================================================================
# Apache Web Server Initialization Script
# ============================================================================
# This script handles Apache-specific setup and verification.
#
# Purpose:
#   - Verify Apache is properly configured
#   - Enable required Apache modules
#   - Check that the document root is correctly set
#   - Ensure Apache is running
#
# Called by: startup.sh (main initialization script)
# ============================================================================

# Color codes for output formatting
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Helper function to print status messages
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# Function: Check Apache Configuration
# ============================================================================
# Validates that Apache configuration is syntactically correct
check_apache_config() {
    echo "Checking Apache configuration..."
    
    if apache2ctl configtest > /dev/null 2>&1; then
        print_status "Apache configuration is valid"
        return 0
    else
        print_warning "Apache configuration may have issues"
        apache2ctl configtest
        return 1
    fi
}

# ============================================================================
# Function: Enable Apache Modules
# ============================================================================
# Enables critical Apache modules needed for web development
enable_apache_modules() {
    echo "Enabling Apache modules..."
    
    # Enable mod_rewrite (for URL rewriting and clean URLs)
    if a2enmod rewrite > /dev/null 2>&1; then
        print_status "mod_rewrite enabled (URL rewriting support)"
    else
        print_warning "mod_rewrite already enabled or error occurred"
    fi
    
    # Enable mod_headers (for HTTP header manipulation)
    if a2enmod headers > /dev/null 2>&1; then
        print_status "mod_headers enabled (HTTP header control)"
    else
        print_warning "mod_headers already enabled or error occurred"
    fi
    
    # Enable mod_ssl (for HTTPS support)
    if a2enmod ssl > /dev/null 2>&1; then
        print_status "mod_ssl enabled (HTTPS/SSL support)"
    else
        print_warning "mod_ssl already enabled or error occurred"
    fi
}

# ============================================================================
# Function: Verify Document Root
# ============================================================================
# Ensures the Apache document root is set correctly to /workspaces/.../public
verify_document_root() {
    echo "Verifying document root configuration..."
    
    EXPECTED_ROOT="/workspaces/cis047-course-template/public"
    
    # Check if document root directory exists
    if [ -d "$EXPECTED_ROOT" ]; then
        print_status "Document root directory exists: $EXPECTED_ROOT"
    else
        print_error "Document root does not exist: $EXPECTED_ROOT"
        mkdir -p "$EXPECTED_ROOT"
        print_status "Created document root directory"
    fi
    
    # Ensure proper permissions on document root
    chmod -R 755 "$EXPECTED_ROOT"
    print_status "Document root permissions set to 755"
}

# ============================================================================
# Function: Start Apache Service
# ============================================================================
# Starts the Apache web server if not already running
start_apache() {
    echo "Checking Apache service status..."
    
    if pgrep -x "apache2" > /dev/null; then
        print_status "Apache is already running"
        return 0
    else
        echo "Starting Apache web server..."
        apache2ctl start > /dev/null 2>&1
        
        # Wait a moment for Apache to start
        sleep 2
        
        if pgrep -x "apache2" > /dev/null; then
            print_status "Apache started successfully"
            return 0
        else
            print_error "Failed to start Apache"
            return 1
        fi
    fi
}

# ============================================================================
# Function: Display Apache Status
# ============================================================================
# Shows Apache version and key configuration details
display_apache_status() {
    echo ""
    echo "Apache Status:"
    apache2 -v | head -1
    
    # Show listening ports
    echo "Listening on: http://localhost:80 and https://localhost:443"
}

# ============================================================================
# Main Execution
# ============================================================================
# This section runs when the script is executed

echo "=========================================="
echo "Apache Web Server Initialization"
echo "=========================================="
echo ""

# Run all Apache setup steps
check_apache_config
echo ""

enable_apache_modules
echo ""

verify_document_root
echo ""

start_apache
echo ""

display_apache_status
echo ""

print_status "Apache initialization complete"
echo ""
