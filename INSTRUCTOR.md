# CIS 047 - Instructor Guide

Welcome! This guide explains how to use, maintain, and customize the CIS 047 course template for your students. This document assumes you have basic GitHub knowledge but may be new to Docker and containerized development environments.

## Table of Contents

- [Overview](#overview)
- [How the Codespace Works](#how-the-codespace-works)
- [System Architecture](#system-architecture)
- [Managing the Environment](#managing-the-environment)
- [Adding and Managing Assignments](#adding-and-managing-assignments)
- [Working with the Database](#working-with-the-database)
- [Updating PHP and Dependencies](#updating-php-and-dependencies)
- [Reusing the Template](#reusing-the-template)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Overview

### What is This Template?

This is a complete, cloud-based web development learning environment for CIS 047. Students don't need to install software—everything runs in **GitHub Codespaces**, a cloud-based VS Code editor with Docker containers.

### Key Benefits

- **Zero Setup for Students** - No local software installation required
- **Consistent Environment** - All students have identical development setups
- **Cloud-Based** - Works on any computer with a web browser
- **Built-in Examples** - PHP, MySQL, and web development examples included
- **Version Control** - Git integration for tracking student work
- **Easy to Update** - Modify the template, students get new versions

### What Students See

Students receive a link to this GitHub repository. They click one button to launch their personal Codespace. Inside, they see:

1. A code editor (VS Code) in their browser
2. A file explorer showing course materials
3. A terminal for running commands
4. A live preview of their website
5. Database connectivity to MySQL

---

## How the Codespace Works

### What is a Codespace?

A **Codespace** is a complete development environment running in the cloud. Think of it as:

- **Like a Remote Desktop** - You're accessing a computer in Microsoft's data centers
- **Based on Docker** - The environment is defined by configuration files (Dockerfile, docker-compose.yml)
- **Integrated with VS Code** - The editor runs in your browser, same as local VS Code
- **Persistent** - Your work is saved even after you close the browser

### GitHub Codespaces vs. Local Development

| Feature | Codespaces | Local |
|---------|-----------|-------|
| Setup Time | 30-60 seconds | Hours (PHP, MySQL, Apache, Node setup) |
| Student Learning Curve | Lower (just click a button) | Higher (installation issues) |
| Consistency | Perfect (all identical) | Variable (OS, version differences) |
| Cost | Free with GitHub education plan | Free but time to set up |
| No Installation | ✓ Yes | ✗ Requires setup |
| Mobile Friendly | ✓ Works on iPad | ✗ Requires computer |

### The Container Lifecycle

**First Launch:**
1. Student clicks "Create codespace on main"
2. GitHub provisions a container (about 60 seconds)
3. The `Dockerfile` runs, installing PHP 8.2, Apache, MySQL, extensions
4. Port 80 (web), 3306 (MySQL) are forwarded to the student's browser
5. Student sees the VS Code editor with your course files

**Subsequent Launches:**
1. Student clicks "Reopen codespace"
2. The same container starts (no provisioning needed)
3. All files from last session are still there
4. Takes about 10-15 seconds to load

**Shutdown:**
- After 30 minutes of inactivity, Codespaces are suspended (not deleted)
- Data is preserved
- Students can resume anytime

---

## System Architecture

### Directory Structure

```
cis047-course-template/
├── .devcontainer/
│   ├── devcontainer.json      # Codespaces configuration (START HERE)
│   ├── Dockerfile             # Container setup (PHP, Apache, MySQL)
│   ├── docker-compose.yml     # Multi-container orchestration
│   └── startup.sh             # Initialization script
│
├── examples/
│   ├── database-connect.php   # Test database connection
│   ├── display-students.php   # Query and display data
│   ├── search-products.php    # Search functionality
│   └── add-customer.php       # Insert data
│
├── database/
│   ├── sample.sql             # Schema and sample data
│   └── init.sql               # Database initialization
│
├── public/                     # Web root (what students visit)
│   ├── index.php
│   ├── css/
│   ├── js/
│   └── images/
│
├── assignments/               # Student assignment folders
│   ├── 01-html-basics/
│   ├── 02-css-styling/
│   └── README.md
│
├── README.md                   # Student-facing guide
└── INSTRUCTOR.md               # This file
```

### How Services Connect

```
Student's Browser
        ↓
   Codespace (Browser-based VS Code)
        ↓
   ┌─────────────────┬─────────────────┐
   ↓                 ↓                 ↓
Apache (Port 80)  MySQL (Port 3306)  Node.js (Port 3000)
   ↓
 public/ folder
 (PHP files + HTML/CSS/JS)
```

### The `.devcontainer/` Folder (Most Important)

This folder defines your entire environment. When a student launches a Codespace, GitHub reads these files:

**devcontainer.json** - The main configuration file
```json
{
  "image": "mcr.microsoft.com/devcontainers/php:8.2",
  "features": {
    "ghcr.io/devcontainers/features/mysql": "8.0"
  },
  "customizations": {
    "vscode": {
      "extensions": [
        "ritwickdey.LiveServer",
        "felixbecker.php-debug"
      ]
    }
  },
  "forwardPorts": [80, 3306, 3000]
}
```

**Dockerfile** - Installs additional packages and configures Apache/PHP

**docker-compose.yml** - Runs multiple containers (Apache, MySQL) together

**startup.sh** - Runs automatically when Codespace starts (sets up database, etc.)

---

## Managing the Environment

### Viewing and Debugging Codespaces

#### Check Codespace Status
1. Go to github.com
2. Click your profile → **Your codespaces**
3. See all active and suspended Codespaces
4. Click one to reopen it

#### Access Terminal/Logs
Inside your Codespace:
1. Look at the bottom panel in VS Code
2. Click **"Terminal"** tab
3. You can run commands like `docker ps` (see running containers)
4. View startup logs to debug issues

#### View Running Services
```bash
# In the terminal, type:
docker ps

# Output shows:
CONTAINER ID   NAMES
abc123         apache-container
def456         mysql-container
```

### Common Terminal Commands

**Check if Apache is running:**
```bash
sudo systemctl status apache2
```

**Check MySQL connectivity:**
```bash
mysql -h db -u cis047_user -pcis047_password cis047_course -e "SELECT 1"
```

**View PHP version:**
```bash
php --version
```

**Restart services:**
```bash
sudo systemctl restart apache2
sudo systemctl restart mysql
```

### Storage and Backups

- **Student files are saved** in the Codespace's persistent storage
- **GitHub backs up everything** in the repository automatically
- **When a student commits and pushes**, their code is backed up on GitHub
- **You can retrieve old versions** by viewing commit history on GitHub

---

## Adding and Managing Assignments

### Creating a New Assignment

#### Step 1: Create Assignment Folder

In your Codespace:
1. Navigate to `assignments/`
2. Right-click → **New Folder**
3. Name it `03-javascript-basics/` (following the naming pattern)
4. Inside, create a `README.md` file

#### Step 2: Write Assignment README

Create `assignments/03-javascript-basics/README.md`:

```markdown
# Assignment 3: JavaScript Basics

## Objective
Create an interactive webpage using JavaScript to manipulate the DOM.

## Requirements
1. Create an HTML file with a button and text element
2. Write JavaScript code to handle button clicks
3. Display/hide content when button is clicked
4. Submit your files to the assignments folder

## Deliverables
- `index.html` - HTML file
- `script.js` - JavaScript file
- `NOTES.md` - Document your learning

## Due Date
[DATE]

## Grading Rubric
- Code works correctly (50%)
- Code is commented (25%)
- Submitted on time (25%)
```

#### Step 3: Provide Examples (Optional)

Create example files in your assignment folder to guide students:

```
assignments/03-javascript-basics/
├── README.md
├── example.html          # Example solution (optional)
└── example.js            # Example code (optional)
```

#### Step 4: Publish Update

1. Commit your changes
2. Push to GitHub
3. All students will see the new assignment on next Codespace load

### Managing Assignment Submissions

**Where students submit:**
- They create files in their assignment folder
- They commit and push to GitHub
- You can see their work by viewing the repository

**Reviewing student work:**
1. Go to your GitHub repository
2. Click **"Code"** tab
3. Navigate to `assignments/01-html-basics/`
4. See all student folders and their files
5. Click on a student's file to review code
6. View the commit history to see progress

**Giving Feedback:**
Use GitHub's code review features:
1. Open a student's file
2. Hover over a line number
3. Click the comment icon (💬)
4. Type feedback
5. Students see your comments

### Archiving Old Assignments

Keep the template clean by moving completed assignments to a separate branch:

```bash
# Create a new branch for archived assignments
git checkout -b assignments/spring-2024

# Move completed assignment folders here
# Commit and push to this branch
git push origin assignments/spring-2024
```

---

## Working with the Database

### Understanding the Database Setup

The `.devcontainer/init-db.sql` file is the canonical database initialization source. It contains:

**Schema (Table Structure):**
```sql
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    major VARCHAR(100),
    gpa DECIMAL(3,2),
    enrollment_date DATE,
    phone VARCHAR(20)
);
```

**Sample Data (5 students plus product seed data):**
- Names reflect San Jose area demographics
- Realistic emails and phone numbers
- Varying GPAs for teaching examples

### Modifying Sample Data

**To add more students:**

1. Open `.devcontainer/init-db.sql` in your Codespace
2. Scroll to the INSERT statements
3. Add a new student record:

```sql
INSERT INTO students 
    (first_name, last_name, email, major, gpa, enrollment_date, phone) 
VALUES
    ('James', 'Park', 'james.park@university.edu', 'Computer Science', 3.65, '2025-01-20', '(408) 555-0111');
```

4. Save the file
5. Reset the database volume to reload the canonical sample data

**To modify table structure:**

1. Open `.devcontainer/init-db.sql`
2. Find the `CREATE TABLE` statement
3. Add new columns (example - add a `gpa_status` field):

```sql
ALTER TABLE students ADD COLUMN gpa_status VARCHAR(50);
```

4. Reset the database volume for the schema changes to take effect

### Connecting to MySQL Directly

Sometimes you want to query the database manually:

**From Codespace Terminal:**
```bash
# Connect to MySQL with the student application credentials
mysql -h db -u cis047_user -pcis047_password cis047_course

# You now see the MySQL prompt (mysql>)
# Run SQL commands:
mysql> SELECT * FROM students;
mysql> INSERT INTO students VALUES (...);
mysql> EXIT;
```

**Using VS Code MySQL Extension:**
1. Install "MySQL" extension in VS Code
2. Click the MySQL icon in the sidebar
3. Click "New Connection"
4. Host: `db`, User: `cis047_user`, Password: `cis047_password`, Database: `cis047_course`
5. Browse tables visually and run queries

### Resetting the Database

If students corrupt the database (don't worry, this happens!):

1. In the Codespace terminal:
```bash
# Stop and remove the containers and database volume
docker-compose down -v

# Restart (automatically reinitializes from .devcontainer/init-db.sql)
docker-compose up -d
```

2. The database returns to original state with all sample data

---

## Updating PHP and Dependencies

### Checking Current Versions

In the Codespace terminal:

```bash
# PHP version
php --version

# Apache version
apache2ctl -v

# MySQL version
mysql --version

# Node.js version (if installed)
node --version
```

### Updating PHP

The PHP version is specified in `.devcontainer/devcontainer.json`:

```json
"image": "mcr.microsoft.com/devcontainers/php:8.2"
```

**To upgrade to PHP 8.3:**

1. Edit `.devcontainer/devcontainer.json`
2. Change `"php:8.2"` to `"php:8.3"`
3. Save and commit
4. Students' next Codespace rebuild will use PHP 8.3

**Note:** Rebuilding the container takes 60+ seconds.

### Installing PHP Extensions

If you need a PHP extension (like `imagick` for image processing):

1. Edit `.devcontainer/Dockerfile`
2. Add to the RUN section:

```dockerfile
RUN apt-get update && apt-get install -y \
    php8.2-imagick \
    php8.2-gd
```

3. Save and commit
4. Students' next rebuild will include these extensions

### Adding Node.js Packages

If you teach Node.js or want npm packages:

1. Create a `package.json` in the root folder:

```json
{
  "name": "cis047-course",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "ejs": "^3.1.0"
  }
}
```

2. In `.devcontainer/Dockerfile`, add:

```dockerfile
RUN npm install
```

3. Students will have these packages available

---

## Reusing the Template for Future Semesters

### End of Semester Tasks

**Week Before Semester Ends:**
1. Collect final student work (it's all on GitHub already)
2. Archive student assignments to a branch:

```bash
git checkout -b archive/fall-2026
git push origin archive/fall-2026
```

3. Clean up example files (optional)
4. Document any changes for next instructor

**After Semester:**
1. Delete old Codespaces (students' personal environments)
2. Keep the template repository clean
3. Create a new branch for next semester's updates

### Preparing for Next Semester

**1. Update Assignments**

```bash
git checkout main
# Remove old assignment solutions or examples
git rm -r assignments/01-html-basics/example.*
git commit -m "Clean up examples for next semester"
git push origin main
```

**2. Update Sample Data**

Update `.devcontainer/init-db.sql` with new student/product data if needed.

**3. Update Course Content**

Modify lessons, examples, or assignment descriptions.

**4. Test Everything**

1. Create a test Codespace
2. Verify all examples work
3. Test database connectivity
4. Ensure all ports forward correctly
5. Delete test Codespace when done

**5. Document Changes**

Create a `CHANGELOG.md` for instructors:

```markdown
# Changes for Spring 2027

## Updated
- Added PHP 8.3 support
- Updated database sample data
- Added 2 new assignments on APIs

## Fixed
- Issue with MySQL connection timeouts
- Live Server port conflicts

## Removed
- Old deprecated examples
```

### Creating a New Instance for a Different Course

If you want to use this template for another course (CIS 048, etc.):

1. **Fork the repository** on GitHub (creates a copy)
2. **Rename it** to `cis048-course-template`
3. **Update configuration:**
   - `.devcontainer/devcontainer.json` - Change display name
   - `README.md` - Update course number and content
   - Database - Change table structure as needed
4. **Update examples** for the new course focus
5. **Commit and push** the changes

### Version Control for Instructors

Keep track of template versions:

```bash
# Tag each semester
git tag -a "fall-2026" -m "CIS 047 Fall 2026 Release"
git push origin fall-2026

# Next semester, branch from the tag
git checkout -b spring-2027 fall-2026
# Make semester-specific changes
```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue: Codespace won't start

**Symptoms:** "Waiting for Codespace to start" hangs for 5+ minutes

**Solution:**
1. Cancel the operation (close the tab)
2. Go to github.com → Your codespaces
3. Delete the stuck Codespace
4. Create a new one (GitHub provisions fresh)
5. If still broken, it may be a GitHub issue (rare)

#### Issue: MySQL "connection refused"

**Symptoms:** `mysqli_connect(): Connection refused`

**Solution:**
1. MySQL might still be starting (wait 30 seconds after launch)
2. Check if MySQL container is running:
   ```bash
   docker ps | grep mysql
   ```
3. If not running, restart:
   ```bash
   docker-compose up -d mysql
   ```

#### Issue: PHP files show blank page

**Symptoms:** Browser shows blank white screen, no errors

**Common causes:**
1. File is in wrong folder (should be in `public/`)
2. PHP syntax error (check browser console with F12)
3. Check PHP error logs:
   ```bash
   tail -f /var/log/apache2/error.log
   ```

#### Issue: Students can't see port 80 forwarding

**Symptoms:** "Ports" panel shows no ports, or shows port 80 as "private"

**Solution:**
1. Click the port entry
2. Change visibility from "Private" to "Public"
3. Copy the public URL and share with student

#### Issue: Database changes don't persist

**Symptoms:** Added data disappears after restart

**Solution:**
1. Database might be reinitialized from `.devcontainer/init-db.sql` after a volume reset
2. To make persistent changes:
   - Add INSERT statements to `.devcontainer/init-db.sql`
   - Or commit the change and restart the container
3. Remember: Codespaces are temporary; data is preserved but not guaranteed

### Getting Help

**GitHub Codespaces Documentation:**
- https://docs.github.com/en/codespaces

**Docker Documentation:**
- https://docs.docker.com/ (understand containers better)

**PHP/MySQL Issues:**
- Stack Overflow (search your error message)
- Official PHP and MySQL docs

---

## Best Practices

### For Managing the Course

✅ **Do:**
- Commit regularly (multiple times per week)
- Test all examples before giving to students
- Document changes in a CHANGELOG or commit messages
- Use meaningful branch names (`assignments/spring-2027`)
- Keep `.devcontainer/` relatively simple (easier to maintain)
- Provide clear example code for students to learn from
- Test Codespaces before each semester starts

❌ **Don't:**
- Modify `.devcontainer/` without testing the rebuild
- Leave debugging files in the repository
- Store large files (>10MB) in Git (use .gitignore)
- Edit files directly on GitHub (use your Codespace)
- Give students write access to the main template
- Forget to restart Docker when making config changes

### For Student Success

✅ **Help students by:**
- Providing clear example files with comments
- Documenting assignment requirements in README files
- Showing error messages and how to debug
- Teaching them to read PHP/MySQL errors (they're usually helpful)
- Encouraging commits (helps track progress and prevent loss)
- Having students test before submitting

❌ **Avoid:**
- Making environment so complex that students can't understand it
- Changing things mid-semester without notifying students
- Leaving deprecated example files that confuse students
- Assuming students know Git/Docker (teach as needed)

### Semester Workflow

**Week 1 (Course Start):**
- ✅ Test Codespace setup with a fresh launch
- ✅ Verify all examples work
- ✅ Send students link to repository
- ✅ Have them launch first Codespace
- ✅ Walk through README guide in class

**Weeks 2-14 (Ongoing):**
- ✅ Review student work on GitHub regularly
- ✅ Give feedback via code comments
- ✅ Monitor GitHub Issues if students report problems
- ✅ Update assignments as needed (commit changes)
- ✅ Keep database/examples current

**Week 15 (Finals):**
- ✅ Final assignment review
- ✅ Archive student work to a branch
- ✅ Document what worked/didn't work

**After Semester:**
- ✅ Clean up repository
- ✅ Delete unused Codespaces
- ✅ Plan updates for next semester
- ✅ Share notes with other instructors

---

## Quick Reference for Instructors

| Task | How To |
|------|--------|
| Add new assignment | Create folder in `assignments/` with README |
| Update PHP version | Edit `.devcontainer/devcontainer.json`, change `php:8.2` to desired version |
| Add PHP extension | Edit `.devcontainer/Dockerfile`, add to RUN apt-get install |
| Modify database | Edit `.devcontainer/init-db.sql` |
| View student code | Go to GitHub → Navigate to assignment folder |
| Reset database | Terminal: `docker-compose down -v` then `docker-compose up -d` |
| Check services | Terminal: `docker ps` |
| Test Codespace | "Create codespace on main" button |
| Archive semester | `git checkout -b archive/fall-2026` then `git push` |

---

## Additional Resources

### For Instructors Learning Docker

- **Docker Fundamentals:** https://www.docker.com/products/docker-desktop/
- **Codespaces Guide:** https://docs.github.com/en/codespaces
- **Quick Docker Intro:** https://www.docker.com/blog/back-to-school-with-docker/

### Templates and Examples

- **GitHub Codespaces Templates:** https://github.com/codespaces/templates
- **Dev Container Specs:** https://containers.dev/

### Teaching Tips

- **GitHub Education:** https://education.github.com/ (free classroom tools)
- **Classroom for GitHub:** https://classroom.github.com/ (manage student work)
- **GitHub Discussion Boards:** Enable for student Q&A

---

**Questions?** Reach out to your institution's IT support or consult the GitHub Codespaces documentation.

**Happy teaching!** 🎓
