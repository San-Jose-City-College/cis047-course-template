<?php
/**
 * ============================================================================
 * CIS 047 - Shared Database Configuration
 * ============================================================================
 *
 * File: db-config.php
 * Purpose: Centralizes database connection settings for all example files.
 *          Include this file instead of repeating credentials everywhere.
 *
 * Security note: In a real production application, credentials should be
 * stored outside the web root (e.g., in environment variables or a .env
 * file) and never committed to version control. For this course example,
 * they are kept here for simplicity.
 *
 * Usage: require_once __DIR__ . '/db-config.php';
 *
 * ============================================================================
 */

$db_host     = 'db';               // Docker service hostname
$db_user     = 'cis047_user';      // Application database user (non-root)
$db_password = 'cis047_password';  // Application database password
$db_name     = 'cis047_course';    // Database name
$db_port     = 3306;               // Default MySQL port
