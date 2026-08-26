<?php
/**
 * ============================================================================
 * CIS 047 - Display Students Example
 * ============================================================================
 * 
 * File: display-students.php
 * Purpose: Demonstrates how to query the students table and display results
 *          in a formatted HTML table.
 * 
 * This example shows:
 * - Connecting to MySQL database
 * - Writing and executing a SELECT query
 * - Fetching results into an associative array
 * - Displaying results in an HTML table
 * - Error handling for database operations
 * - Formatting data for display
 * 
 * ============================================================================
 */

// Set error reporting to display all errors during development
error_reporting(E_ALL);
ini_set('display_errors', 1);

require __DIR__ . '/db-config.php';

// ============================================================================
// Create Database Connection
// ============================================================================
// Create a new MySQLi connection object with the database credentials

$conn = new mysqli($db_host, $db_user, $db_password, $db_name, $db_port);

// Check if connection was successful
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Set character encoding to UTF-8
if (!$conn->set_charset("utf8mb4")) {
    die("Error loading character set utf8mb4: " . $conn->error);
}

// ============================================================================
// Query the Students Table
// ============================================================================
// Build a SELECT query to retrieve all student records, ordered by last name

$query = "SELECT student_id, first_name, last_name, email, major, gpa, enrollment_date 
          FROM students 
          ORDER BY last_name, first_name";

// Execute the query
// The query() method sends the SQL to the database server
$result = $conn->query($query);

// Check if the query was successful
if (!$result) {
    die("Query failed: " . $conn->error);
}

// Get the number of rows returned by the query
$num_rows = $result->num_rows;

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CIS 047 - Display Students</title>
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
            padding: 40px 20px;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            margin-bottom: 10px;
            font-size: 32px;
        }

        .header p {
            font-size: 14px;
            opacity: 0.9;
        }

        .content {
            padding: 30px;
        }

        .stats {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }

        .stats strong {
            color: #667eea;
            font-size: 18px;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        thead {
            background-color: #f8f9fa;
            border-bottom: 2px solid #667eea;
        }

        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
            color: #555;
        }

        tbody tr:hover {
            background-color: #f8f9fa;
        }

        tbody tr:nth-child(even) {
            background-color: #fafbfc;
        }

        .student-name {
            font-weight: 600;
            color: #333;
        }

        .gpa {
            font-weight: 600;
            color: #667eea;
        }

        .gpa-high {
            color: #28a745;
        }

        .gpa-medium {
            color: #ffc107;
        }

        .gpa-low {
            color: #dc3545;
        }

        .footer {
            background-color: #f8f9fa;
            padding: 20px 30px;
            border-top: 1px solid #eee;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        .back-link:hover {
            background-color: #5568d3;
        }

        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .no-data p {
            font-size: 16px;
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 24px;
            }

            th, td {
                padding: 10px;
                font-size: 12px;
            }

            .table-wrapper {
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>👥 Student Directory</h1>
            <p>CIS 047 - Intro to Web Development</p>
        </div>

        <div class="content">
            <div class="stats">
                <strong><?php echo $num_rows; ?></strong> students found in the database
            </div>

            <?php
            // ================================================================
            // Display Results in a Table
            // ================================================================
            // Check if there are any results to display

            if ($num_rows > 0) {
                // There are students to display
                echo '<div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Major</th>
                                    <th>GPA</th>
                                    <th>Enrollment Date</th>
                                </tr>
                            </thead>
                            <tbody>';

                // Fetch each row from the result set
                // fetch_assoc() returns the next row as an associative array
                // where the keys are the column names
                while ($row = $result->fetch_assoc()) {
                    // Determine GPA color class for visual feedback
                    $gpa_class = '';
                    if ($row['gpa'] >= 3.7) {
                        $gpa_class = 'gpa-high';
                    } elseif ($row['gpa'] >= 3.3) {
                        $gpa_class = 'gpa-medium';
                    } else {
                        $gpa_class = 'gpa-low';
                    }

                    // Format the enrollment date for better readability
                    $enrollment_date = date('M d, Y', strtotime($row['enrollment_date']));

                    // Output the table row with the student data
                    echo '<tr>
                            <td>' . htmlspecialchars($row['student_id']) . '</td>
                            <td class="student-name">' . htmlspecialchars($row['first_name']) . ' ' . htmlspecialchars($row['last_name']) . '</td>
                            <td>' . htmlspecialchars($row['email']) . '</td>
                            <td>' . htmlspecialchars($row['major']) . '</td>
                            <td class="gpa ' . $gpa_class . '">' . number_format($row['gpa'], 2) . '</td>
                            <td>' . $enrollment_date . '</td>
                          </tr>';
                }

                echo '  </tbody>
                        </table>
                    </div>';
            } else {
                // No students found
                echo '<div class="no-data">
                        <p>No students found in the database.</p>
                        <p>Please check the database connection and try again.</p>
                      </div>';
            }
            ?>
        </div>

        <div class="footer">
            <a href="database-connect.php" class="back-link">← Back to Connection Test</a>
            <br>
            <a href="search-products.php" class="back-link">Search Products →</a>
        </div>
    </div>
</body>
</html>

<?php
// ============================================================================
// Close Database Connection
// ============================================================================
// Free the result set memory
$result->free();

// Close the database connection
$conn->close();
?>
