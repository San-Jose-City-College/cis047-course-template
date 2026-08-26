<?php
/**
 * ============================================================================
 * CIS 047 - PHP Basics Example
 * ============================================================================
 * 
 * File: php-example.php
 * Purpose: Demonstrates basic PHP concepts in a browser-friendly page.
 * 
 * This example shows:
 * - Variables and data types
 * - Arrays and associative arrays
 * - Functions
 * - Control structures (if/elseif)
 * - Loops (foreach)
 * - Mixing PHP with HTML output
 * 
 * ============================================================================
 */

// ============================================================================
// PHP Logic (runs before any HTML is sent to the browser)
// ============================================================================

// Variables and data types
$name = "John Doe";
$age = 20;
$gpa = 3.85;
$isEnrolled = true;

// Arrays
$courses = array(
    "CIS 047 - Web Development",
    "CIS 050 - Database Design",
    "CIS 100 - Programming Fundamentals"
);

// Associative array
$student = array(
    "name" => $name,
    "age"  => $age,
    "gpa"  => $gpa,
    "enrolled" => $isEnrolled
);

// Function definition
function gradeStudent($score) {
    if ($score >= 90) {
        return "A";
    } elseif ($score >= 80) {
        return "B";
    } elseif ($score >= 70) {
        return "C";
    } else {
        return "F";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CIS 047 - PHP Basics Example</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container {
            max-width: 650px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px 30px;
            text-align: center;
        }
        .header h1 { font-size: 28px; margin-bottom: 6px; }
        .header p  { font-size: 14px; opacity: 0.9; }
        .content   { padding: 30px; }
        .section {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            border-radius: 5px;
            padding: 15px 20px;
            margin-bottom: 20px;
        }
        .section h2 { color: #667eea; font-size: 16px; margin-bottom: 10px; }
        .row {
            display: flex;
            justify-content: space-between;
            padding: 6px 0;
            border-bottom: 1px solid #dee2e6;
            font-size: 14px;
        }
        .row:last-child { border-bottom: none; }
        .row .label  { font-weight: 600; color: #333; }
        .row .value  { color: #555; }
        ul { list-style: disc; margin-left: 20px; color: #555; font-size: 14px; }
        ul li { padding: 4px 0; }
        .grade-badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 4px 14px;
            border-radius: 20px;
            font-weight: 700;
            font-size: 18px;
        }
        .footer {
            background: #f8f9fa;
            padding: 20px 30px;
            border-top: 1px solid #eee;
            text-align: center;
        }
        .back-link {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        .back-link:hover { background: #5568d3; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🐘 PHP Basics Example</h1>
            <p>CIS 047 - Intro to Web Development</p>
        </div>

        <div class="content">

            <!-- Student Information (from associative array) -->
            <div class="section">
                <h2>Student Information</h2>
                <div class="row">
                    <span class="label">Name:</span>
                    <span class="value"><?php echo htmlspecialchars($student['name']); ?></span>
                </div>
                <div class="row">
                    <span class="label">Age:</span>
                    <span class="value"><?php echo $student['age']; ?></span>
                </div>
                <div class="row">
                    <span class="label">GPA:</span>
                    <span class="value"><?php echo number_format($student['gpa'], 2); ?></span>
                </div>
                <div class="row">
                    <span class="label">Enrolled:</span>
                    <span class="value"><?php echo $student['enrolled'] ? 'Yes' : 'No'; ?></span>
                </div>
            </div>

            <!-- Courses (from indexed array + foreach loop) -->
            <div class="section">
                <h2>Courses Enrolled</h2>
                <ul>
                    <?php foreach ($courses as $course): ?>
                        <li><?php echo htmlspecialchars($course); ?></li>
                    <?php endforeach; ?>
                </ul>
            </div>

            <!-- Function call result -->
            <div class="section">
                <h2>Grade Calculator</h2>
                <div class="row">
                    <span class="label">Score: 85</span>
                    <span class="value">
                        Grade: <span class="grade-badge"><?php echo gradeStudent(85); ?></span>
                    </span>
                </div>
                <div class="row">
                    <span class="label">Score: 92</span>
                    <span class="value">
                        Grade: <span class="grade-badge"><?php echo gradeStudent(92); ?></span>
                    </span>
                </div>
                <div class="row">
                    <span class="label">Score: 65</span>
                    <span class="value">
                        Grade: <span class="grade-badge"><?php echo gradeStudent(65); ?></span>
                    </span>
                </div>
            </div>

        </div>

        <div class="footer">
            <a href="database-connect.php" class="back-link">Test Database Connection →</a>
        </div>
    </div>
</body>
</html>
