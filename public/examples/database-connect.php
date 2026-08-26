<?php
/**
 * ============================================================================
 * CIS 047 - Database Connection Example
 * ============================================================================
 * 
 * File: database-connect.php
 * Purpose: Demonstrates how to connect to a MySQL database and verify the
 *          connection is successful.
 * 
 * This is a beginner-friendly example showing:
 * - How to establish a MySQL connection using MySQLi
 * - Basic error handling
 * - Displaying connection status
 * 
 * Database Connection Details:
 *   - Host: db (Docker container hostname)
 *   - Database: classdb
 *   - User: cis047_user
 *   - Password: cis047_password
 *   - Port: 3306 (default MySQL port)
 * 
 * ============================================================================
 */

// Set the error reporting level to show all errors
error_reporting(E_ALL);
ini_set('display_errors', 1);

// ============================================================================
// Database Configuration
// ============================================================================
// These variables store the database connection information.
// In production, these should be stored in a separate config file not
// accessible from the web root.

$db_host = 'db';           // Host name or IP address of MySQL server
$db_user = 'cis047_user';         // MySQL user name
$db_password = 'cis047_password';     // MySQL password
$db_name = 'classdb';      // Database name
$db_port = 3306;           // MySQL port (default is 3306)

// ============================================================================
// Create Connection
// ============================================================================
// The mysqli() constructor creates a new database connection.
// It takes 4 parameters: host, user, password, and database name.
// 
// The connection is stored in the $conn variable so we can use it
// to perform database queries.

$conn = new mysqli($db_host, $db_user, $db_password, $db_name, $db_port);

// ============================================================================
// Check Connection for Errors
// ============================================================================
// If the connection fails, mysqli will set the connect_error property.
// We check if there's an error and display an appropriate message.

if ($conn->connect_error) {
    // Connection failed - display error message and stop script
    die("Connection failed: " . $conn->connect_error);
}

// ============================================================================
// Set Character Set
// ============================================================================
// Set the character set to UTF-8 to properly handle international characters.
// This ensures data is stored and retrieved correctly.

if (!$conn->set_charset("utf8mb4")) {
    die("Error loading character set utf8mb4: " . $conn->error);
}

// ============================================================================
// HTML Output
// ============================================================================
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CIS 047 - Database Connection Test</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 500px;
            width: 100%;
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 28px;
        }

        .subtitle {
            color: #666;
            margin-bottom: 30px;
            font-size: 14px;
        }

        .success {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #28a745;
            margin-bottom: 20px;
        }

        .info-box {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .info-box h3 {
            color: #1565c0;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #b3d9ff;
            font-size: 14px;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .label {
            font-weight: 600;
            color: #333;
        }

        .value {
            color: #666;
        }

        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 25px;
        }

        a {
            flex: 1;
            display: inline-block;
            padding: 12px;
            text-align: center;
            background-color: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
            font-size: 14px;
            font-weight: 500;
        }

        a:hover {
            background-color: #5568d3;
        }

        .secondary {
            background-color: #6c757d;
        }

        .secondary:hover {
            background-color: #5a6268;
        }

        code {
            background-color: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>✓ Database Connection Successful</h1>
        <p class="subtitle">CIS 047 - Intro to Web Development</p>

        <div class="success">
            <strong>Success!</strong> Your application is successfully connected to the MySQL database.
        </div>

        <div class="info-box">
            <h3>Connection Details</h3>
            <div class="info-row">
                <span class="label">Host:</span>
                <span class="value"><?php echo $db_host; ?></span>
            </div>
            <div class="info-row">
                <span class="label">Database:</span>
                <span class="value"><?php echo $db_name; ?></span>
            </div>
            <div class="info-row">
                <span class="label">User:</span>
                <span class="value"><?php echo $db_user; ?></span>
            </div>
            <div class="info-row">
                <span class="label">Port:</span>
                <span class="value"><?php echo $db_port; ?></span>
            </div>
        </div>

        <div class="info-box">
            <h3>Server Information</h3>
            <div class="info-row">
                <span class="label">MySQL Version:</span>
                <span class="value"><?php echo $conn->server_info; ?></span>
            </div>
            <div class="info-row">
                <span class="label">Character Set:</span>
                <span class="value"><?php echo $conn->character_set_name(); ?></span>
            </div>
        </div>

        <div class="button-group">
            <a href="display-students.php">View Students</a>
            <a href="search-products.php" class="secondary">Search Products</a>
        </div>
    </div>
</body>
</html>

<?php
// Close the database connection when done
// This is good practice to free up server resources
$conn->close();
?>
