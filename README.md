# CIS 047 - Intro to Web Development

Welcome to CIS 047! 🎉 This guide will help you get started with your coursework using GitHub Codespaces and the web development environment.

## Table of Contents

- [What You'll Need](#what-youll-need)
- [Getting Started](#getting-started)
- [Opening a Codespace](#opening-a-codespace)
- [Working with Files](#working-with-files)
- [Previewing Your Website](#previewing-your-website)
- [Using PHP](#using-php)
- [Connecting to MySQL](#connecting-to-mysql)
- [Example Projects](#example-projects)
- [Saving Your Work](#saving-your-work)
- [Committing and Pushing](#committing-and-pushing)
- [Troubleshooting](#troubleshooting)
- [Getting Help](#getting-help)

---

## What You'll Need

Before you start, make sure you have:

- A **GitHub account** (free) - [Sign up here](https://github.com/signup)
- A **web browser** (Chrome, Firefox, Safari, or Edge)
- An **internet connection**
- That's it! Everything else is provided for you.

**No software to install.** All the tools you need (PHP, MySQL, Apache) are already set up in the cloud. ☁️

---

## Getting Started

### Step 1: Access the Course Repository

Your instructor will give you a link to the course repository on GitHub. Click the link to open it.

You'll see a green button that says **"Code"** near the top right. Click it.

### Step 2: Open in Codespace

When you click the **"Code"** button, you'll see options. Look for **"Codespaces"** and click **"Create codespace on main"**.

**[Screenshot: The Code button menu with Codespace option]**

A new tab will open and load your development environment. This takes about 30-60 seconds. Be patient! ⏳

Once it loads, you'll see a dark editor window that looks like this:

**[Screenshot: VS Code editor showing file explorer on left]**

Congratulations! You're now in your Codespace. This is your personal cloud-based development environment where you can write code, test websites, and store your work.

---

## Opening a Codespace

### First time opening a Codespace:

1. Go to the course repository on GitHub
2. Click the green **"Code"** button
3. Click **"Codespaces"**
4. Click **"Create codespace on main"**
5. Wait for it to load (about 1 minute)

### Next time (opening an existing Codespace):

1. Go to the course repository on GitHub
2. Click the green **"Code"** button
3. Look for your existing Codespace in the list
4. Click on it to reopen it

Your Codespace saves automatically, so everything you worked on last time will be there waiting for you.

---

## Working with Files

The left side of your editor shows the **File Explorer**. This is like a folder view on your computer.

### Viewing Files

Click on any file in the explorer to open it. You'll see its contents in the main editor window.

**[Screenshot: File explorer with folders and files]**

### Creating New Files

Right-click in the File Explorer and select **"New File"**. Type a filename (like `index.html`) and press Enter.

### Editing Files

Click in the editor to start typing. Your changes are automatically saved. 💾

### The Public Folder

Your website files should go in the **`public/`** folder. Files in this folder are what appears on the web when you preview your site.

---

## Previewing Your Website

### Starting the Web Server

When you first open your Codespace, the web server starts automatically. You'll see messages in the bottom panel.

### Opening Your Website Preview

Look at the bottom right of your editor. You'll see a section called **"Ports"**.

**[Screenshot: Ports section at bottom of VS Code]**

Click on the **port 80** or **http://localhost** link. This opens your website in a preview window.

### Viewing in a New Tab

You can also click the **"Open in Browser"** button to see your site in a full web browser tab.

The URL will look like: `https://[your-codespace-name].preview.app.github.dev`

---

## Using PHP

PHP is a programming language for building dynamic websites. The course includes several **PHP examples** that show you how to:

- Connect to a database
- Display data
- Search records
- Add new entries

### Example Files

Look in the **`public/examples/`** folder. You'll find:

- **`database-connect.php`** - Tests your database connection
- **`display-students.php`** - Shows student records in a table
- **`search-products.php`** - Shows how to search and display results
- **`add-customer.php`** - Shows how to insert new data

### Running Examples

PHP files must be served through the web server (Apache) to execute — they won't work if you open them directly from the file explorer.

1. Open the **Ports** panel at the bottom of the editor
2. Click the link next to **port 80** to open your site in the browser
3. Add `/examples/database-connect.php` to the end of the URL

For example: `https://[your-codespace-name].preview.app.github.dev/examples/database-connect.php`

### Writing Your Own PHP

PHP files must end with `.php` (like `mypage.php`).

Here's a simple example:

```php
<?php
  // This is a PHP comment
  echo "Hello, World!";
?>
```

The `<?php` and `?>` markers tell the server that it's PHP code. The `echo` command displays text on the page.

---

## Connecting to MySQL

The database is already running and ready to use! The course includes sample data you can query.

### Database Connection Details

- **Host:** `db`
- **Database:** `classdb`
- **Username:** `cis047_user`
- **Password:** `cis047_password`

### Sample Data

The database includes two tables:

**students** table:
- student_id, first_name, last_name, email, major, gpa, enrollment_date, phone

**products** table:
- product_id, product_name, category, price, quantity_stock, supplier, description, sku

### Using the Examples

The **example files** in the `public/examples/` folder show you how to query this data with PHP:

1. **database-connect.php** - Verifies the connection works
2. **display-students.php** - Runs a SELECT query and displays results in a table
3. **search-products.php** - Takes user input and searches the database
4. **add-customer.php** - Takes form data and inserts a new student record

Open these files to see how to write your own database code!

### Viewing the Database

If you want to see the raw database directly:

1. Open the **VS Code Command Palette** (press `Ctrl+Shift+P` on Windows or `Cmd+Shift+P` on Mac)
2. Type **"MySQL"** and look for a MySQL client extension
3. Follow the prompts to connect using the details above
4. You can now browse tables and run SQL queries directly

---

## Example Projects

## Example Projects

The `public/examples/` folder contains complete, working examples:

### 1. Test Your Connection: database-connect.php

This shows you:
- How to create a connection
- How to check for errors
- How to display the connection details

**To test it:**
1. Open port 80 in the Ports panel
2. Navigate to `/examples/database-connect.php`
3. You should see a success message and server details

### 2. Display Data: display-students.php

This shows you:
- How to run a SELECT query
- How to loop through results
- How to display results in an HTML table

**To use it:**
1. Open port 80 in the Ports panel
2. Navigate to `/examples/display-students.php`
3. You'll see all students in a formatted table

### 3. Search Records: search-products.php

This shows you:
- How to create a search form
- How to use the LIKE operator in SQL
- How to display search results

**To use it:**
1. Open port 80 in the Ports panel
2. Navigate to `/examples/search-products.php`
3. Search for a product (try "wireless" or "desk")
4. Results display in cards

### 4. Insert Data: add-customer.php

This shows you:
- How to create a form
- How to validate input
- How to insert a new record into the database

**To use it:**
1. Open port 80 in the Ports panel
2. Navigate to `/examples/add-customer.php`
3. Fill out the form and click "Add Student"
4. You'll see a success message with the new student ID

---

## Saving Your Work

### Automatic Saving

Your files are **saved automatically** as you type. You don't need to press Ctrl+S (but you can if you want).

### Where Are My Files?

All your files are stored in the cloud in your Codespace. They're also backed up on GitHub.

---

## Committing and Pushing

### What Are Git and GitHub?

- **Git** is a tool that keeps track of changes to your code
- **GitHub** is a website where you store your code in the cloud
- **Committing** means saving a version of your work with a description
- **Pushing** means uploading your committed work to GitHub

Think of it like: `Save locally → Commit with message → Push to cloud`

### Why Do This?

- It keeps a history of your work
- Your code is backed up on GitHub
- You can see what changed and when
- Your instructor can review your code

### Making Your First Commit

#### Step 1: View Changes

Look at the left sidebar. You'll see an icon that looks like a **circle with lines** (Source Control). Click it.

**[Screenshot: Source Control icon]**

You'll see a list of files you've changed.

#### Step 2: Stage Your Changes

In the Source Control panel, hover over each file you want to commit. Click the **"+"** button to "stage" it.

**[Screenshot: Staging files]**

Or click **"Stage All Changes"** to stage everything at once.

#### Step 3: Write a Commit Message

At the top of the Source Control panel, you'll see a text box that says "Message (Ctrl+Enter to commit)".

Type a short description of what you changed:

```
Add student profile page
Fix database connection bug
Complete assignment 3
```

**Good commit messages:**
- Start with an action word (Add, Fix, Update, Complete)
- Be specific about what changed
- Keep it short (under 50 characters if possible)

#### Step 4: Commit

Press `Ctrl+Enter` (Windows) or `Cmd+Enter` (Mac) to commit.

Or click the **"✓"** (checkmark) button.

**[Screenshot: Commit button]**

#### Step 5: Push to GitHub

After committing, you'll see a blue button that says **"Sync Changes"** or **"Push"**.

Click it to upload your work to GitHub.

**[Screenshot: Sync Changes button]**

Congratulations! Your work is now on GitHub. Your instructor can see it. ✓

### Checking Your Work on GitHub

1. Go to the repository on GitHub
2. Look for your recent commits (you'll see your message and timestamp)
3. Click on a commit to see exactly what changed
4. This proves your work is there!

### Making More Commits

Each time you finish a task or make progress:

1. Make changes to your files
2. Go to Source Control
3. Stage your changes
4. Write a message describing what you did
5. Commit (Ctrl+Enter)
6. Push (Sync Changes)

**Do this regularly** (multiple times per assignment). It shows progress and protects your work.

---

## Troubleshooting

### Problem: "Connection refused" or "Can't connect to database"

The database might still be starting up. Wait 30 seconds and try again.

If it still doesn't work:
1. Look at the Terminal at the bottom
2. Check for error messages
3. Try closing and reopening your Codespace

### Problem: Website shows blank page or error

1. Check the browser console for errors (press F12)
2. Look at the PHP error messages
3. Make sure your `.php` file is in the `public/` folder
4. Check that your database connection details are correct

### Problem: Changes don't appear on website

1. Save the file (Ctrl+S)
2. Refresh the browser (F5 or Cmd+R)
3. If it's a database change, the cache might need to clear

### Problem: File Explorer is empty or won't open

1. Click **"File"** at the top left
2. Select **"Open Folder"**
3. Choose `/workspaces/cis047-course-template`
4. Click **"OK"** and trust the workspace if prompted

### Problem: Codespace won't load

1. Go to github.com
2. Click your profile icon (top right)
3. Select **"Your codespaces"**
4. If one is loading, wait a bit longer
5. You can delete old Codespaces and create a new one

### Problem: I accidentally deleted a file

Don't worry! GitHub has backups. Go to GitHub and look at the code history. You can see previous versions of files.

---

## Getting Help

### Ask Your Instructor

Your instructor is here to help! Come to office hours or email them with questions.

### Check the Documentation

- **PHP Documentation:** https://www.php.net/manual/
- **MySQL Documentation:** https://dev.mysql.com/doc/
- **HTML/CSS Reference:** https://developer.mozilla.org/
- **GitHub Docs:** https://docs.github.com/

### Common Resources

- YouTube tutorials for PHP and MySQL
- Stack Overflow (search your error message)
- GitHub Discussions (if your instructor has enabled it)

### Still Stuck?

1. Take a screenshot of the error
2. Note the exact steps you were taking
3. Email your instructor with the screenshot
4. They can help you troubleshoot

---

## Tips for Success

✅ **Do these things:**
- Commit your work regularly (multiple times per assignment)
- Test your code in the preview before submitting
- Read error messages carefully—they usually tell you what's wrong
- Ask questions early (don't wait until the assignment is due!)
- Save your work by pushing to GitHub

❌ **Avoid these things:**
- Don't wait until the last minute to start assignments
- Don't ignore error messages
- Don't forget to push your code (just committing isn't enough)
- Don't edit files directly on GitHub (use your Codespace)

---

## Quick Reference

| Task | How To |
|------|--------|
| Open your Codespace | GitHub → Code → Codespaces → Select yours |
| Create a new file | Right-click in File Explorer → New File |
| Preview your website | Click the port 80 link in Ports panel |
| View a database table | Open port 80 link → navigate to `/examples/display-students.php` |
| Save a file | Just keep typing (saves automatically) |
| Make a commit | Source Control panel → Stage → Message → Commit |
| Push to GitHub | Click Sync Changes button |
| Check your code on GitHub | Go to repository → Click Commits |

---

**Good luck with CIS 047! You've got this! 💪**

For questions or problems, reach out to your instructor.
