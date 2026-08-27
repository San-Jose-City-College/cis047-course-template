<?php
/**
 * ============================================================================
 * CIS 047 - Search Products Example
 * ============================================================================
 * 
 * File: search-products.php
 * Purpose: Demonstrates how to build a search form and query the database
 *          based on user input.
 * 
 * This example shows:
 * - Creating an HTML form for user input
 * - Processing form submissions (GET method)
 * - Using WHERE clause in SQL queries
 * - Using LIKE operator for partial text matching
 * - Displaying filtered results
 * - Error handling for user input
 * - Security: using prepared statements (best practice)
 * 
 * ============================================================================
 */

// Set error reporting to display all errors during development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// ============================================================================
// Database Configuration
// ============================================================================

require_once __DIR__ . '/db-config.php';

// ============================================================================
// Create Database Connection
// ============================================================================

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
// Process Search Form
// ============================================================================
// Check if the user submitted a search query

$search_query = '';
$search_results = null;
$num_results = 0;
$error_message = '';

// Check if form was submitted using GET method
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['search'])) {
    // Get the search term from the form and trim whitespace
    $search_query = trim($_GET['search']);

    // Validate that search query is not empty
    if (strlen($search_query) > 0) {
        // Use prepared statement for security (prevents SQL injection)
        // The ? is a placeholder for the search term
        $query = "SELECT product_id, product_name, category, price, quantity_stock, description 
                  FROM products 
                  WHERE product_name LIKE ? 
                  OR category LIKE ? 
                  OR description LIKE ? 
                  ORDER BY category, product_name";

        // Prepare the statement
        $stmt = $conn->prepare($query);

        // Check if prepare was successful
        if (!$stmt) {
            $error_message = "Prepare failed: " . $conn->error;
        } else {
            // Add wildcard characters to the search term for partial matching
            $search_term = '%' . $search_query . '%';

            // Bind the search term to the three ? placeholders
            // 's' means the parameter is a string
            $stmt->bind_param('sss', $search_term, $search_term, $search_term);

            // Execute the prepared statement
            if (!$stmt->execute()) {
                $error_message = "Execute failed: " . $stmt->error;
            } else {
                // Get the results
                $search_results = $stmt->get_result();
                $num_results = $search_results->num_rows;
            }
        }
    } else {
        $error_message = "Please enter a search term.";
    }
}

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CIS 047 - Search Products</title>
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
            max-width: 900px;
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

        .search-box {
            background-color: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            margin-bottom: 30px;
            border: 2px solid #e9ecef;
        }

        .search-box h2 {
            font-size: 16px;
            color: #333;
            margin-bottom: 15px;
        }

        .search-form {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .search-form input[type="text"] {
            flex: 1;
            min-width: 200px;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            font-family: inherit;
            transition: border-color 0.3s;
        }

        .search-form input[type="text"]:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .search-form button {
            padding: 12px 30px;
            background-color: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .search-form button:hover {
            background-color: #5568d3;
        }

        .search-form button:active {
            transform: translateY(1px);
        }

        .results-section {
            margin-top: 30px;
        }

        .results-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }

        .results-header strong {
            color: #667eea;
            font-size: 16px;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #f5c6cb;
            margin-bottom: 20px;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .no-results p {
            font-size: 16px;
            margin-bottom: 10px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .product-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }

        .product-name {
            font-size: 16px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .product-category {
            display: inline-block;
            background-color: #e9ecef;
            color: #667eea;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 12px;
        }

        .product-description {
            font-size: 13px;
            color: #666;
            margin-bottom: 15px;
            line-height: 1.5;
        }

        .product-details {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #e9ecef;
        }

        .product-price {
            font-size: 18px;
            font-weight: 700;
            color: #28a745;
        }

        .product-stock {
            font-size: 12px;
            color: #999;
        }

        .stock-available {
            color: #28a745;
            font-weight: 600;
        }

        .stock-low {
            color: #ffc107;
            font-weight: 600;
        }

        .stock-out {
            color: #dc3545;
            font-weight: 600;
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

        @media (max-width: 768px) {
            .header h1 {
                font-size: 24px;
            }

            .search-form {
                flex-direction: column;
            }

            .search-form input[type="text"],
            .search-form button {
                width: 100%;
            }

            .product-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔍 Search Products</h1>
            <p>CIS 047 - Intro to Web Development</p>
        </div>

        <div class="content">
            <!-- Search Form -->
            <div class="search-box">
                <h2>Find a Product</h2>
                <form method="GET" class="search-form">
                    <input 
                        type="text" 
                        name="search" 
                        placeholder="Search by product name, category, or description..." 
                        value="<?php echo htmlspecialchars($search_query, ENT_QUOTES, 'UTF-8'); ?>"
                        required
                    >
                    <button type="submit">Search</button>
                </form>
            </div>

            <!-- Results Section -->
            <?php
            // ================================================================
            // Display Search Results
            // ================================================================

            // Check if there was an error
            if (!empty($error_message)) {
                echo '<div class="error-message">' . htmlspecialchars($error_message, ENT_QUOTES, 'UTF-8') . '</div>';
            }

            // Check if a search was performed
            if ($search_results !== null) {
                echo '<div class="results-section">';
                echo '<div class="results-header">
                        Found <strong>' . $num_results . '</strong> product(s) matching "' . htmlspecialchars($search_query, ENT_QUOTES, 'UTF-8') . '"
                      </div>';

                if ($num_results > 0) {
                    // Display results in a grid
                    echo '<div class="product-grid">';

                    // Loop through each product result
                    while ($row = $search_results->fetch_assoc()) {
                        // Determine stock status for display
                        if ($row['quantity_stock'] == 0) {
                            $stock_class = 'stock-out';
                            $stock_text = 'Out of Stock';
                        } elseif ($row['quantity_stock'] < 10) {
                            $stock_class = 'stock-low';
                            $stock_text = 'Low Stock (' . $row['quantity_stock'] . ' left)';
                        } else {
                            $stock_class = 'stock-available';
                            $stock_text = 'In Stock (' . $row['quantity_stock'] . ' available)';
                        }

                        // Display product card
                        echo '<div class="product-card">
                                <div class="product-name">' . htmlspecialchars($row['product_name'], ENT_QUOTES, 'UTF-8') . '</div>
                                <span class="product-category">' . htmlspecialchars($row['category'], ENT_QUOTES, 'UTF-8') . '</span>
                                <div class="product-description">' . htmlspecialchars($row['description'], ENT_QUOTES, 'UTF-8') . '</div>
                                <div class="product-details">
                                    <div>
                                        <div class="product-price">$' . number_format($row['price'], 2) . '</div>
                                        <div class="product-stock">
                                            <span class="' . $stock_class . '">' . $stock_text . '</span>
                                        </div>
                                    </div>
                                </div>
                              </div>';
                    }

                    echo '</div>';
                } else {
                    // No products found
                    echo '<div class="no-results">
                            <p>No products found matching your search.</p>
                            <p>Try searching for a different term.</p>
                          </div>';
                }

                echo '</div>';
            }
            ?>
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
// Free the result set memory if it exists
if ($search_results !== null) {
    $search_results->free();
}

// Close the database connection
$conn->close();
?>
