
#!/usr/bin/env bash
set -euo pipefail

# CIS 047: Update database permissions for existing Codespaces.
# Run from the repository root or any subdirectory.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Updating CIS 047 database permissions..."

# Use the existing MySQL administrator credentials.
# This connects to the database service, not localhost.
MYSQL_PWD=root mysql \
  --disable-ssl \
  -h db \
  -u root \
  < "$SCRIPT_DIR/database-permissions.sql"

echo "Success! Database permissions have been updated."
echo "You can now create databases using cis047_user."
