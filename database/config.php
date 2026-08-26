<?php
/**
 * Database Configuration
 * This file contains the database connection settings
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
