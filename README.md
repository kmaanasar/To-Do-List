# Todo List Web Application

A modern, responsive todo list application built with Java servlets, JSP, and modern CSS. Features a clean interface with dark mode support and priority-based task management.

## Features

- **Task Management**: Create, edit, delete, and mark tasks as complete
- **Priority Levels**: Organize tasks with High, Medium, and Low priorities
- **Filtering**: View all tasks, active tasks only, or completed tasks
- **Dark Mode**: Toggle between light and dark themes
- **Responsive Design**: Works on desktop and mobile devices
- **Data Persistence**: Tasks are saved to CSV files
- **Modern UI**: Clean interface with animations and hover effects

## Tech Stack

- **Backend**: Java 11, Servlets 4.0, JSP 2.3
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Styling**: Custom CSS with Poppins font
- **Build Tool**: Maven 3
- **Server**: Jetty (development)
- **Data Storage**: CSV files

## Project Structure

```
src/
├── main/
│   ├── java/
│   │   └── com/todoapp/
│   │       ├── filter/
│   │       │   └── CharacterEncodingFilter.java
│   │       ├── model/
│   │       │   └── TodoItem.java
│   │       ├── service/
│   │       │   └── TodoService.java
│   │       └── servlet/
│   │           └── TodoServlet.java
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml
│       │   ├── todo.jsp
│       │   └── error.jsp
│       ├── css/
│       │   └── style.css
│       ├── js/
│       │   └── script.js
│       └── index.jsp
└── test/
    └── java/
```

## Prerequisites

- Java 11 or higher
- Maven 3.6 or higher
- Web browser (Chrome, Firefox, Safari, Edge)

## Installation & Setup

1. **Clone the repository** (or download the source code)
   ```bash
   git clone <your-repository-url>
   cd todo-list-app
   ```

2. **Build the project**
   ```bash
   mvn clean compile
   ```

3. **Run the application**
   ```bash
   mvn jetty:run
   ```

4. **Access the application**
   Open your browser and navigate to:
   ```
   http://localhost:8080/todo-app/
   ```

## Usage

### Adding Tasks
1. Enter your task in the input field
2. Select a priority level (Low, Medium, High)
3. Click "Add Task" or press Enter

### Managing Tasks
- **Complete Task**: Click the checkbox next to a task
- **Edit Task**: Click on the task text to open the edit modal
- **Delete Task**: Click the × button (confirms before deletion)

### Filtering
- **All**: Show all tasks
- **Active**: Show only incomplete tasks
- **Completed**: Show only completed tasks

### Dark Mode
Click the "Dark Mode" button in the header to toggle between light and dark themes. Your preference is saved in browser storage.

## Configuration

### Custom Port
To run on a different port:
```bash
mvn jetty:run -Djetty.port=8081
```

### Data Storage
Tasks are automatically saved to a CSV file in your system's temporary directory. The location varies by operating system:
- Windows: `%TEMP%\todos.csv`
- macOS/Linux: `/tmp/todos.csv`

## Development

### File Structure
- **Model**: `TodoItem.java` - Data structure for individual tasks
- **Service**: `TodoService.java` - Business logic and file operations
- **Controller**: `TodoServlet.java` - HTTP request handling
- **View**: `todo.jsp` - Main user interface
- **Assets**: CSS and JavaScript in `webapp` directory

### Building for Production
```bash
mvn clean package
```
This creates a `todo-app.war` file in the `target/` directory that can be deployed to any servlet container.

## Browser Support

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Troubleshooting

### Common Issues

**Port 8080 already in use**
- Use a different port: `mvn jetty:run -Djetty.port=8081`

**CSS/JS files not loading**
- Check browser developer tools for 404 errors
- Verify files exist in `src/main/webapp/css/` and `src/main/webapp/js/`

**Tasks not saving**
- Check file permissions in system temp directory
- Look for error messages in console output

**Build errors**
- Ensure Java 11+ is installed: `java -version`
- Verify Maven is installed: `mvn -version`
- Run `mvn clean install` to resolve dependencies

## Contact

For questions or support, please open an issue in the repository.
