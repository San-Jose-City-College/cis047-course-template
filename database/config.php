<?php
/**
 * Database Configuration
 * ============================================================================
 * This file contains the shared database connection settings for the course.
 *
 * HOW TO USE IN YOUR OWN PHP FILES:
 *   Add this line near the top of any PHP file that needs a database connection:
 *
 *     require_once __DIR__ . '/../../database/config.php';
 *
 *   (Adjust the path based on where your file lives relative to this file.)
 *   After that line, the $conn variable is ready to use — no need to reconnect.
 *
 * NOTE: This file is NOT loaded automatically. You must include it explicitly.
 *       The example files in public/examples/ all use this file.
 * ============================================================================
 */

// Database credentials
define('DB_SERVER', 'db');
define('DB_USERNAME', 'cis047_user');
define('DB_PASSWORD', 'cis047_password');
define('DB_NAME', 'classdb');

// Create connection
$conn = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set charset to utf8mb4
$conn->set_charset("utf8mb4");

// Optional: Display connection status (remove in production)
// echo "Connected successfully to " . DB_NAME . " database";
?>
