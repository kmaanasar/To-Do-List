function editTask(id, task, priority) {
    const modal = document.getElementById('editModal');
    const editId = document.getElementById('editId');
    const editTaskInput = document.getElementById('editTask');
    const editPriority = document.getElementById('editPriority');

    editId.value = id;
    editTaskInput.value = task;
    editPriority.value = (priority || 'MEDIUM').toUpperCase();

    modal.classList.add('show');
    editTaskInput.focus();
}

function closeEditModal() {
    const modal = document.getElementById('editModal');
    modal.classList.remove('show');
}

// Close modal when clicking outside content
window.addEventListener('click', function (event) {
    const modal = document.getElementById('editModal');
    if (event.target === modal) closeEditModal();
});

// Close modal with Escape key
document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') closeEditModal();
});

// DOM ready
document.addEventListener('DOMContentLoaded', function () {
    // Focus main input
    const mainInput = document.querySelector('input[name="task"]');
    if (mainInput) mainInput.focus();

    // Ripple effect
    const buttons = document.querySelectorAll('.add-btn, .save-btn, .cancel-btn');
    buttons.forEach(button => {
        button.addEventListener('click', function (e) {
            const ripple = document.createElement('span');
            const rect = this.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = e.clientX - rect.left - size / 2;
            const y = e.clientY - rect.top - size / 2;

            ripple.style.width = ripple.style.height = size + 'px';
            ripple.style.left = x + 'px';
            ripple.style.top = y + 'px';
            ripple.classList.add('ripple');

            this.appendChild(ripple);
            setTimeout(() => ripple.remove(), 600);
        });
    });

    // Animate todo items
    const todoItems = document.querySelectorAll('.todo-item');
    todoItems.forEach((item, index) => {
        item.style.animationDelay = `${index * 50}ms`;
    });

    // Add form validation
    const addForm = document.querySelector('.add-todo-form');
    if (addForm) {
        addForm.addEventListener('submit', function (e) {
            const taskInput = this.querySelector('input[name="task"]');
            const task = taskInput.value.trim();

            if (task.length < 1) {
                e.preventDefault();
                taskInput.focus();
                showNotification('Please enter a task', 'error');
                return;
            }
            if (task.length > 200) {
                e.preventDefault();
                taskInput.focus();
                showNotification('Task is too long (max 200 characters)', 'error');
                return;
            }
        });
    }

    // Edit form validation
    const editForm = document.getElementById('editForm');
    if (editForm) {
        editForm.addEventListener('submit', function (e) {
            const taskInput = document.getElementById('editTask');
            const task = taskInput.value.trim();
            if (task.length < 1) {
                e.preventDefault();
                taskInput.focus();
                showNotification('Please enter a task', 'error');
                return;
            }
            if (task.length > 200) {
                e.preventDefault();
                taskInput.focus();
                showNotification('Task is too long (max 200 characters)', 'error');
                return;
            }
        });
    }

    // Delegate clicks on task text (safer than inline JS)
    document.querySelectorAll('.task-text').forEach(span => {
        span.addEventListener('click', () => {
            editTask(span.dataset.id, span.dataset.task, span.dataset.priority);
        });
    });
});

// Notifications
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    document.body.appendChild(notification);
    requestAnimationFrame(() => notification.classList.add('show'));
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Keyboard shortcuts
document.addEventListener('keydown', function (e) {
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
        const activeForm = document.querySelector('form:focus-within');
        if (activeForm) activeForm.submit();
    }
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
        e.preventDefault();
        const mainInput = document.querySelector('input[name="task"]');
        if (mainInput) mainInput.focus();
    }
});

// Optional future hooks
function confirmBulkDelete() { return confirm('Are you sure you want to delete all completed tasks?'); }

function filterTasks(query) {
    const tasks = document.querySelectorAll('.todo-item');
    const lowerQuery = (query || '').toLowerCase();
    tasks.forEach(task => {
        const taskText = task.querySelector('.task-text').textContent.toLowerCase();
        task.style.display = taskText.includes(lowerQuery) ? 'flex' : 'none';
    });
}
