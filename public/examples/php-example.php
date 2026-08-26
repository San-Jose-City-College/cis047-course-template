<?php
/**
 * PHP Example
 * Demonstrates basic PHP concepts
 */

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
    "age" => $age,
    "gpa" => $gpa,
    "enrolled" => $isEnrolled
);

// Function
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

// Output
echo "Student Information:\n";
echo "Name: " . $student["name"] . "\n";
echo "Age: " . $student["age"] . "\n";
echo "GPA: " . $student["gpa"] . "\n";
echo "\nCourses:\n";
foreach ($courses as $course) {
    echo "- " . $course . "\n";
}

echo "\nGrade for 85: " . gradeStudent(85);
?>
