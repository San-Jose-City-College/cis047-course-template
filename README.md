# CIS 047 Web Development Course Template

This is a GitHub Codespaces template repository for the CIS 047 introductory web development course. It provides a complete development environment and starter structure for learning HTML, CSS, JavaScript, PHP, and MySQL.

## 🚀 Quick Start with Codespaces

1. Click the **Code** button on this repository
2. Select **Codespaces** tab
3. Click **Create codespace on main**
4. Wait for the environment to load (usually 1-2 minutes)
5. Your development environment is ready!

## 📁 Repository Structure

```
cis047-course-template/
├── .devcontainer/              # GitHub Codespaces configuration
│   ├── devcontainer.json      # Codespaces environment setup
│   ├── Dockerfile             # Custom development container
│   └── docker-compose.yml     # Multi-container orchestration
│
├── lessons/                    # Course lesson materials
│   ├── 01-html-basics.md
│   ├── 02-css-styling.md
│   └── 03-javascript-basics.md
│
├── examples/                   # Code examples for reference
│   ├── html-example.html      # HTML structure example
│   ├── css-example.css        # CSS styling example
│   ├── javascript-example.js  # JavaScript code example
│   └── php-example.php        # PHP fundamentals example
│
├── assignments/                # Student assignments
│   ├── 01-html-basics/
│   ├── 02-css-styling/
│   ├── 03-javascript-basics/
│   └── README.md              # Assignment overview
│
├── public/                     # Web-accessible files (Apache document root)
│   ├── index.php              # Home page
│   ├── css/
│   │   └── style.css          # Main stylesheet
│   ├── js/
│   │   └── script.js          # Main JavaScript file
│   └── images/                # Image assets
│
├── database/                   # Database files
│   ├── schema.sql             # Database schema
│   ├── seed.sql               # Sample data
│   └── config.php             # Database connection config
│
└── README.md                   # This file
```

## 📚 Folder Purposes

### `.devcontainer/`
- Configures the GitHub Codespaces environment
- Sets up PHP 8.2 with Apache
- Includes Node.js, MySQL client, and development tools
- Installs recommended VSCode extensions (Live Server, PHP Debug, Prettier, ESLint)
- Automatically forwards ports: 80 (web), 3000 (Node), 3306 (MySQL)

### `lessons/`
- Contains course lesson materials in Markdown format
- Each lesson corresponds to a major topic
- Links to relevant examples and assignments

### `examples/`
- Reference code for each technology
- `html-example.html` - Semantic HTML structure
- `css-example.css` - Responsive CSS patterns
- `javascript-example.js` - DOM manipulation and events
- `php-example.php` - PHP syntax and basics
- Students can view and learn from these examples

### `assignments/`
- Contains individual assignment folders
- Each assignment has a README with requirements
- Students complete assignments in their respective folders
- Includes grading rubrics and deliverables

### `public/`
- **Apache document root** - All web-accessible files go here
- `index.php` - Home page entry point
- `css/` - Stylesheets folder
- `js/` - JavaScript files folder
- `images/` - Image assets folder
- When using Codespaces, the web server serves files from this directory

### `database/`
- `schema.sql` - Creates database tables (students, courses, enrollments, assignments)
- `seed.sql` - Populates database with sample data
- `config.php` - PHP database connection and credentials
- Students use these for MySQL assignments

## 🔧 Technology Stack

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Backend**: PHP 8.2
- **Database**: MySQL 8.0
- **Development**: Apache 2.4, Node.js 18
- **Environment**: GitHub Codespaces with Docker

## 📝 Getting Started as a Student

1. **Open Codespaces**: Create a new Codespaces environment from this template
2. **Review Examples**: Check the `examples/` folder for reference code
3. **Read Lessons**: Start with lessons in the `lessons/` folder
4. **Complete Assignments**: Work on assignments in `assignments/` folders
5. **Test Locally**: Use the live server (port 80) to preview your work

## 🖥️ Running the Web Server

The Apache web server automatically starts in Codespaces. To access your application:

1. In Codespaces, look for the **Ports** tab at the bottom
2. Click the globe icon next to port 80 to open the web application
3. Your files in `public/` are automatically served

## 🗄️ Working with MySQL

1. The MySQL database is automatically available on port 3306
2. Database name: `cis047_course`
3. Username: `cis047_user`
4. Password: `cis047_password`
5. Run `schema.sql` and `seed.sql` to create tables and sample data
6. Update `database/config.php` with your connection settings if needed

## 📖 Assignment Workflow

1. Navigate to the assignment folder (e.g., `assignments/01-html-basics/`)
2. Read the `README.md` for requirements
3. Create your files in the assignment folder
4. Test your work using the live server
5. Commit and push your changes to GitHub
6. Submit your work per instructor guidelines

## 🛠️ Useful VS Code Extensions

Automatically installed in Codespaces:
- **Live Server** - Preview changes in real-time
- **Auto Close Tag** - Automatically close HTML/XML tags
- **Prettier** - Code formatter
- **ESLint** - JavaScript linter
- **PHP Debug** - Debug PHP code
- **Intellicode** - AI-assisted code completion

## 🚀 Tips for Success

- **Validate Your Code**: Use W3C validators for HTML and CSS
- **Use Console**: Open browser DevTools (F12) and check the Console tab
- **Read Error Messages**: They often indicate exactly what's wrong
- **Comment Your Code**: Explain what your code does
- **Test Frequently**: Don't wait until the end to test
- **Ask Questions**: Use GitHub Discussions or post to class forum

## 📞 Support

- Check the course syllabus for instructor contact information
- Review course materials and examples
- Use GitHub Issues to report problems with the template
- Refer to official documentation:
  - [MDN Web Docs](https://developer.mozilla.org/)
  - [W3Schools](https://www.w3schools.com/)
  - [PHP Manual](https://www.php.net/manual/)
  - [MySQL Documentation](https://dev.mysql.com/doc/)

## 📄 License

This template is provided as part of the CIS 047 course. See LICENSE file for details.

---

**Happy coding!** 🎉
