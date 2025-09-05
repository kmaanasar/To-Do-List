<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Todo List App</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <header class="header" style="position: relative;">
            <h1>My Todo List</h1>
            <p class="subtitle">Organize your tasks efficiently</p>
            <button id="darkModeToggle" class="add-btn" style="position: absolute; top: 1rem; right: 1rem;" aria-label="Toggle dark mode">Toggle Dark Mode</button>
        </header>

        <!-- Add new todo form -->
        <form class="add-todo-form" method="post" action="${pageContext.request.contextPath}/todos">
            <input type="hidden" name="action" value="add">
            <div class="input-group">
                <input type="text" name="task" placeholder="Add a new task..." required maxlength="200" aria-label="Task text">
                <select name="priority" class="priority-select" aria-label="Priority">
                    <option value="LOW">Low</option>
                    <option value="MEDIUM" selected>Medium</option>
                    <option value="HIGH">High</option>
                </select>
                <button type="submit" class="add-btn">Add Task</button>
            </div>
        </form>

        <!-- Filter buttons -->
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/todos" class="tab ${empty filter ? 'active' : ''}">
                All <span class="count">${totalCount}</span>
            </a>
            <a href="${pageContext.request.contextPath}/todos?filter=active" class="tab ${filter == 'active' ? 'active' : ''}">
                Active <span class="count">${activeCount}</span>
            </a>
            <a href="${pageContext.request.contextPath}/todos?filter=completed" class="tab ${filter == 'completed' ? 'active' : ''}">
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
                        <!-- Toggle (POST) -->
                        <form method="post" action="${pageContext.request.contextPath}/todos" style="display: inline;">
                            <input type="hidden" name="action" value="toggle">
                            <input type="hidden" name="id" value="${todo.id}">
                            <button type="submit" class="check-btn ${todo.completed ? 'checked' : ''}" aria-label="Toggle complete">
                                ${todo.completed ? '✓' : ''}
                            </button>
                        </form>

                        <div class="task-info">
                            <span class="task-text"
                                  data-id="${todo.id}"
                                  data-task="${fn:escapeXml(todo.task)}"
                                  data-priority="${fn:escapeXml(todo.priority)}">
                                ${todo.task}
                            </span>
                            <div class="task-meta">
                                <span class="priority priority-${fn:toLowerCase(todo.priority)}">${todo.priority}</span>
                                <span class="created-date">${todo.createdAt}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Delete (POST) -->
                    <form method="post" action="${pageContext.request.contextPath}/todos" style="display: inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${todo.id}">
                        <button type="submit" class="delete-btn" aria-label="Delete task"
                                onclick="return confirm('Are you sure you want to delete this task?')">×</button>
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
    <div id="editModal" class="modal" aria-modal="true" role="dialog">
        <div class="modal-content">
            <h3>Edit Task</h3>
            <form method="post" action="${pageContext.request.contextPath}/todos" id="editForm">
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

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggleBtn = document.getElementById('darkModeToggle');
            if (localStorage.getItem('theme') === 'dark') {
                document.documentElement.classList.add('dark');
            }
            toggleBtn.addEventListener('click', () => {
                const isDark = document.documentElement.classList.toggle('dark');
                localStorage.setItem('theme', isDark ? 'dark' : 'light');
            });
        });
    </script>
</body>
</html>
