<?php
/**
 * ============================================================================
 * CIS 047 - Add Student Example
 * ============================================================================
 * 
 * File: add-customer.php
 * Purpose: Demonstrates how to insert new records into a database table
 *          using an HTML form and prepared statements.
 * 
 * This example shows:
 * - Creating an HTML form for user input
 * - Processing form submissions (POST method)
 * - Validating user input
 * - Using INSERT statements to add records
 * - Using prepared statements for security (prevents SQL injection)
 * - Displaying success/error messages
 * - Handling database errors gracefully
 * 
 * ============================================================================
 */

// Set error reporting to display all errors during development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// ============================================================================
// Database Connection
// ============================================================================
// Load shared database configuration. This gives us the $conn variable
// without duplicating connection settings in every file.

require_once __DIR__ . '/../../database/config.php';

// ============================================================================
// Initialize Variables
// ============================================================================

$success_message = '';
$error_message = '';
$form_data = array(
    'first_name' => '',
    'last_name' => '',
    'email' => '',
    'phone' => '',
    'major' => ''
);

// ============================================================================
// Process Form Submission
// ============================================================================
// Check if the form was submitted using POST method

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get form data and trim whitespace
    $first_name = trim($_POST['first_name'] ?? '');
    $last_name = trim($_POST['last_name'] ?? '');
    $email = trim($_POST['email'] ?? '');
    $phone = trim($_POST['phone'] ?? '');
    $major = trim($_POST['major'] ?? '');

    // Store form data for re-display in case of error
    $form_data = array(
        'first_name' => $first_name,
        'last_name' => $last_name,
        'email' => $email,
        'phone' => $phone,
        'major' => $major
    );

    // ====================================================================
    // Validate Form Input
    // ====================================================================
    // Check that all required fields are filled out

    if (empty($first_name)) {
        $error_message = "First name is required.";
    } elseif (empty($last_name)) {
        $error_message = "Last name is required.";
    } elseif (empty($email)) {
        $error_message = "Email is required.";
    } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        $error_message = "Please enter a valid email address.";
    } elseif (empty($major)) {
        $error_message = "Major is required.";
    }

    // If validation passed, insert the data into the database
    if (empty($error_message)) {
        // ================================================================
        // Insert Record into Database
        // ================================================================
        // Use a prepared statement to safely insert the data
        // This protects against SQL injection attacks

        $query = "INSERT INTO students (first_name, last_name, email, phone, major, enrollment_date) 
                  VALUES (?, ?, ?, ?, ?, CURDATE())";

        // Prepare the statement
        $stmt = $conn->prepare($query);

        // Check if prepare was successful
        if (!$stmt) {
            $error_message = "Database error: " . $conn->error;
        } else {
            // Bind the form data to the prepared statement
            // 'sssss' means all 5 parameters are strings
            $stmt->bind_param('sssss', $first_name, $last_name, $email, $phone, $major);

            // Execute the prepared statement
            if ($stmt->execute()) {
                // Insert was successful
                $success_message = "Student added successfully! ID: " . $stmt->insert_id;
                // Clear the form
                $form_data = array(
                    'first_name' => '',
                    'last_name' => '',
                    'email' => '',
                    'phone' => '',
                    'major' => ''
                );
            } else {
                // Insert failed
                if ($conn->errno == 1062) {
                    // Duplicate entry error
                    $error_message = "This email address is already registered.";
                } else {
                    $error_message = "Error adding customer: " . $stmt->error;
                }
            }

            // Close the statement
            $stmt->close();
        }
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CIS 047 - Add Student</title>
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
            max-width: 600px;
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

        .success-message {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #28a745;
            margin-bottom: 25px;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #f5c6cb;
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        input[type="text"]:focus,
        input[type="email"]:focus,
        input[type="tel"]:focus,
        select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-hint {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }

        .required {
            color: #dc3545;
        }

        .button-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        button {
            flex: 1;
            padding: 12px;
            font-size: 14px;
            font-weight: 600;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
            font-family: inherit;
        }

        button[type="submit"] {
            background-color: #28a745;
            color: white;
        }

        button[type="submit"]:hover {
            background-color: #218838;
        }

        button[type="submit"]:active {
            transform: translateY(1px);
        }

        button[type="reset"] {
            background-color: #6c757d;
            color: white;
        }

        button[type="reset"]:hover {
            background-color: #5a6268;
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

        .form-info {
            background-color: #e7f3ff;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 25px;
            font-size: 13px;
            color: #1565c0;
        }

        @media (max-width: 768px) {
            .header h1 {
                font-size: 24px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>➕ Add Student</h1>
            <p>CIS 047 - Intro to Web Development</p>
        </div>

        <div class="content">
            <!-- Display Messages -->
            <?php
            if (!empty($success_message)) {
                echo '<div class="success-message">✓ ' . htmlspecialchars($success_message) . '</div>';
            }

            if (!empty($error_message)) {
                echo '<div class="error-message">✗ ' . htmlspecialchars($error_message) . '</div>';
            }
            ?>

            <div class="form-info">
                📝 This form demonstrates how to insert new student records into a database using PHP. 
                First name, last name, email, and major are required. Email must be unique.
            </div>

            <!-- Add Customer Form -->
            <form method="POST" action="">
                <div class="form-row">
                    <div class="form-group">
                        <label for="first_name">
                            First Name <span class="required">*</span>
                        </label>
                        <input 
                            type="text" 
                            id="first_name" 
                            name="first_name" 
                            value="<?php echo htmlspecialchars($form_data['first_name']); ?>"
                            placeholder="e.g., Maria"
                            required
                        >
                        <div class="form-hint">Enter the customer's first name</div>
                    </div>

                    <div class="form-group">
                        <label for="last_name">
                            Last Name <span class="required">*</span>
                        </label>
                        <input 
                            type="text" 
                            id="last_name" 
                            name="last_name" 
                            value="<?php echo htmlspecialchars($form_data['last_name']); ?>"
                            placeholder="e.g., Gonzalez"
                            required
                        >
                        <div class="form-hint">Enter the customer's last name</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">
                        Email Address <span class="required">*</span>
                    </label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        value="<?php echo htmlspecialchars($form_data['email']); ?>"
                        placeholder="e.g., maria.gonzalez@example.com"
                        required
                    >
                    <div class="form-hint">Must be a valid email address and unique in the database</div>
                </div>

                <div class="form-group">
                    <label for="phone">
                        Phone Number <span class="required">*</span>
                    </label>
                    <input 
                        type="tel" 
                        id="phone" 
                        name="phone" 
                        value="<?php echo htmlspecialchars($form_data['phone']); ?>"
                        placeholder="e.g., (408) 555-0123"
                        required
                    >
                    <div class="form-hint">Include area code and any dashes or parentheses</div>
                </div>

                <div class="form-group">
                    <label for="major">
                        Major <span class="required">*</span>
                    </label>
                    <input 
                        type="text" 
                        id="major" 
                        name="major" 
                        value="<?php echo htmlspecialchars($form_data['major']); ?>"
                        placeholder="e.g., Computer Science"
                        required
                    >
                    <div class="form-hint">Enter the student's field of study</div>
                </div>

                <div class="button-group">
                    <button type="submit">Add Student</button>
                    <button type="reset">Clear Form</button>
                </div>
            </form>

            <!-- Code Example -->
            <div style="margin-top: 40px; padding-top: 30px; border-top: 1px solid #eee;">
                <h3 style="color: #333; margin-bottom: 15px; font-size: 14px;">How This Works:</h3>
                <ol style="color: #666; font-size: 13px; line-height: 1.8; margin-left: 20px;">
                    <li>User fills out the form with student information</li>
                    <li>Form is submitted using POST method</li>
                    <li>PHP validates that all required fields are filled correctly</li>
                    <li>A prepared statement is created to insert the data safely</li>
                    <li>The database inserts the new student record</li>
                    <li>Success or error message is displayed to the user</li>
                    <li>Form is cleared if successful, keeping data if there's an error</li>
                </ol>
            </div>
        </div>

        <div class="footer">
            <a href="database-connect.php" class="back-link">← Back to Connection Test</a>
            <br>
            <a href="display-students.php" class="back-link">View Students →</a>
        </div>
    </div>
</body>
</html>

<?php
// ============================================================================
// Close Database Connection
// ============================================================================

$conn->close();
?>
