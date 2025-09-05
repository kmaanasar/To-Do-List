<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo List App</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <header class="header">
            <h1>My Todo List</h1>
            <p class="subtitle">Organize your tasks efficiently</p>
        </header>

        <!-- Add new todo form -->
        <form class="add-todo-form" method="post" action="todos">
            <input type="hidden" name="action" value="add">
            <div class="input-group">
                <input type="text" name="task" placeholder="Add a new task..." required maxlength="200">
                <select name="priority" class="priority-select">
                    <option value="LOW">Low</option>
                    <option value="MEDIUM" selected>Medium</option>
                    <option value="HIGH">High</option>
                </select>
                <button type="submit" class="add-btn">Add Task</button>
            </div>
        </form>

        <!-- Filter buttons -->
        <div class="filter-tabs">
            <a href="todos" class="tab ${filter == null ? 'active' : ''}">
                All <span class="count">${totalCount}</span>
            </a>
            <a href="todos?filter=active" class="tab ${filter == 'active' ? 'active' : ''}">
                Active <span class="count">${activeCount}</span>
            </a>
            <a href="todos?filter=completed" class="tab ${filter == 'completed' ? 'active' : ''}">
                Completed <span class="count">${completedCount}</span>
            </a>
        </div>

        <!-- Todo list -->
        <div class="todo-list">
            <c:if test="${empty todos}">
                <div class="empty-state">
                    <p>No tasks found. Add your first task above!</p>
                </div>
            </c:if>

            <c:forEach var="todo" items="${todos}">
                <div class="todo-item ${todo.completed ? 'completed' : ''}" data-id="${todo.id}">
                    <div class="todo-content">
                        <form method="get" action="todos" style="display: inline;">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="id" value="${todo.id}">
                            <button type="submit" class="check-btn ${todo.completed ? 'checked' : ''}">
                                ${todo.completed ? '✓' : ''}
                            </button>
                        </form>
                        
                        <div class="task-info">
                            <span class="task-text" onclick="editTask('${todo.id}', '${fn:escapeXml(todo.task)}', '${fn:escapeXml(todo.priority)}')">${todo.task}</span>
                            <div class="task-meta">
                                <span class="priority priority-${todo.priority.toLowerCase()}">${todo.priority}</span>
                                <span class="created-date">${todo.createdAt}</span>
                            </div>
                        </div>
                    </div>
                    
                    <form method="get" action="todos" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${todo.id}">
                        <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this task?')">×</button>
                    </form>
                </div>
            </c:forEach>
        </div>

        <!-- Statistics -->
        <div class="stats">
            <div class="stat-item">
                <span class="stat-number">${totalCount}</span>
                <span class="stat-label">Total</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${activeCount}</span>
                <span class="stat-label">Active</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${completedCount}</span>
                <span class="stat-label">Completed</span>
            </div>
        </div>
    </div>

    <!-- Edit modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <h3>Edit Task</h3>
            <form method="post" action="todos" id="editForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" id="editId">
                <div class="form-group">
                    <label for="editTask">Task:</label>
                    <input type="text" name="task" id="editTask" required maxlength="200">
                </div>
                <div class="form-group">
                    <label for="editPriority">Priority:</label>
                    <select name="priority" id="editPriority">
                        <option value="LOW">Low</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="HIGH">High</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="submit" class="save-btn">Save</button>
                    <button type="button" onclick="closeEditModal()" class="cancel-btn">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script src="js/script.js"></script>
</body>
</html>