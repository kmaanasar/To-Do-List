<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
            <button id="darkModeToggle" class="add-btn" style="position: absolute; top: 1rem; right: 1rem; padding: 0.5rem 1rem; font-size: 0.8rem;" aria-label="Toggle dark mode">
                Dark Mode
            </button>
        </header>

        <!-- Add new todo form -->
        <form class="add-todo-form" method="post" action="${pageContext.request.contextPath}/todos">
            <input type="hidden" name="action" value="add">
            <div class="input-group">
                <input type="text" name="task" placeholder="Add a new task..." required maxlength="200" aria-label="Task text">
                <select name="priority" class="priority-select" aria-label="Priority">
                    <option value="LOW">Low</option>
                    <option value="MEDIUM" selected="selected">Medium</option>
                    <option value="HIGH">High</option>
                </select>
                <button type="submit" class="add-btn">Add Task</button>
            </div>
        </form>

        <!-- Filter buttons -->
        <div class="filter-tabs">
            <a href="${pageContext.request.contextPath}/todos" class="tab ${empty param.filter ? 'active' : ''}">
                All <span class="count">${not empty totalCount ? totalCount : 0}</span>
            </a>
            <a href="${pageContext.request.contextPath}/todos?filter=active" class="tab ${param.filter eq 'active' ? 'active' : ''}">
                Active <span class="count">${not empty activeCount ? activeCount : 0}</span>
            </a>
            <a href="${pageContext.request.contextPath}/todos?filter=completed" class="tab ${param.filter eq 'completed' ? 'active' : ''}">
                Completed <span class="count">${not empty completedCount ? completedCount : 0}</span>
            </a>
        </div>

        <!-- Todo list -->
        <div class="todo-list">
            <c:choose>
                <c:when test="${empty todos}">
                    <div class="empty-state">
                        <p>
                            <c:choose>
                                <c:when test="${param.filter eq 'active'}">No active tasks! Add one above.</c:when>
                                <c:when test="${param.filter eq 'completed'}">No completed tasks yet.</c:when>
                                <c:otherwise>No tasks found. Add your first task above!</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="todo" items="${todos}">
                        <div class="todo-item ${todo.completed ? 'completed' : ''}" data-id="${todo.id}">
                            <div class="todo-content">
                                <!-- Toggle complete form -->
                                <form method="post" action="${pageContext.request.contextPath}/todos" style="display: inline;">
                                    <input type="hidden" name="action" value="toggle">
                                    <input type="hidden" name="id" value="${todo.id}">
                                    <button type="submit" class="check-btn ${todo.completed ? 'checked' : ''}" aria-label="Toggle complete">
                                        <c:if test="${todo.completed}">✓</c:if>
                                    </button>
                                </form>

                                <div class="task-info">
                                    <span class="task-text" 
                                          data-id="${todo.id}"
                                          data-task="${fn:escapeXml(todo.task)}"
                                          data-priority="${fn:escapeXml(todo.priority)}"
                                          style="cursor: pointer;">
                                        <c:out value="${todo.task}"/>
                                    </span>
                                    <div class="task-meta">
                                        <span class="priority priority-${fn:toLowerCase(todo.priority)}">
                                            <c:out value="${todo.priority}"/>
                                        </span>
                                        <span class="created-date">
                                            <c:out value="${todo.createdAt}"/>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Delete form -->
                            <form method="post" action="${pageContext.request.contextPath}/todos" style="display: inline;" 
                                  onsubmit="return confirm('Are you sure you want to delete this task?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${todo.id}">
                                <button type="submit" class="delete-btn" aria-label="Delete task">×</button>
                            </form>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Statistics -->
        <div class="stats">
            <div class="stat-item">
                <span class="stat-number">${not empty totalCount ? totalCount : 0}</span>
                <span class="stat-label">Total</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${not empty activeCount ? activeCount : 0}</span>
                <span class="stat-label">Active</span>
            </div>
            <div class="stat-item">
                <span class="stat-number">${not empty completedCount ? completedCount : 0}</span>
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
                    <input type="text" name="task" id="editTask" required="required" maxlength="200">
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
                    <button type="submit" class="save-btn">Save Changes</button>
                    <button type="button" class="cancel-btn" onclick="closeEditModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const toggleBtn = document.getElementById('darkModeToggle');
            
            const currentTheme = localStorage.getItem('theme');
            if (currentTheme === 'dark') {
                document.documentElement.classList.add('dark');
                toggleBtn.textContent = 'Light Mode';
            }
            
            toggleBtn.addEventListener('click', function() {
                const isDark = document.documentElement.classList.toggle('dark');
                localStorage.setItem('theme', isDark ? 'dark' : 'light');
                this.textContent = isDark ? 'Light Mode' : 'Dark Mode';
            });
            
            // Add delete confirmation to all delete forms
            document.querySelectorAll('.delete-form').forEach(form => {
                form.addEventListener('submit', function(e) {
                    if (!confirm('Are you sure you want to delete this task?')) {
                        e.preventDefault();
                    }
                });
            });
            
            // Add click handler for edit functionality
            document.querySelectorAll('.task-text').forEach(span => {
                span.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    const task = this.getAttribute('data-task');
                    const priority = this.getAttribute('data-priority');
                    editTask(id, task, priority);
                });
            });
        });
        
        // Show success message if available
        <c:if test="${not empty param.success}">
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof showNotification === 'function') {
                showNotification('Task ${fn:escapeXml(param.success)} successfully!', 'success');
            }
        });
        </c:if>
    </script>
</body>
</html>