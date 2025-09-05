function editTask(id, task, priority) {
    const modal = document.getElementById('editModal');
    const editId = document.getElementById('editId');
    const editTask = document.getElementById('editTask');
    const editPriority = document.getElementById('editPriority');
    
    editId.value = id;
    editTask.value = task;
    editPriority.value = priority;
    
    modal.style.display = 'block';
    editTask.focus();
}

function closeEditModal() {
    const modal = document.getElementById('editModal');
    modal.style.display = 'none';
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('editModal');
    if (event.target === modal) {
        closeEditModal();
    }
}

// Close modal with Escape key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeEditModal();
    }
});

// Auto-focus on the main input when page loads
document.addEventListener('DOMContentLoaded', function() {
    const mainInput = document.querySelector('input[name="task"]');
    if (mainInput) {
        mainInput.focus();
    }
});

// Add some interactive feedback
document.addEventListener('DOMContentLoaded', function() {
    // Add ripple effect to buttons
    const buttons = document.querySelectorAll('.add-btn, .save-btn, .cancel-btn');
    buttons.forEach(button => {
        button.addEventListener('click', function(e) {
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
            
            setTimeout(() => {
                ripple.remove();
            }, 600);
        });
    });
    
    // Add smooth animations for todo items
    const todoItems = document.querySelectorAll('.todo-item');
    todoItems.forEach((item, index) => {
        item.style.animationDelay = `${index * 50}ms`;
        item.classList.add('fade-in');
    });
    
    // Enhanced form validation
    const addForm = document.querySelector('.add-todo-form');
    if (addForm) {
        addForm.addEventListener('submit', function(e) {
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
            
            showNotification('Task added successfully!', 'success');
        });
    }
    
    // Enhanced edit form validation
    const editForm = document.getElementById('editForm');
    if (editForm) {
        editForm.addEventListener('submit', function(e) {
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
            
            showNotification('Task updated successfully!', 'success');
        });
    }
});

// Notification system
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

// Keyboard shortcuts
document.addEventListener('keydown', function(e) {
    // Ctrl/Cmd + Enter to submit form
    if ((e.ctrlKey || e.metaKey) && e.key === 'Enter') {
        const activeForm = document.querySelector('form:focus-within');
        if (activeForm) {
            activeForm.submit();
        }
    }
    
    // Ctrl/Cmd + K to focus search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        const mainInput = document.querySelector('input[name="task"]');
        if (mainInput) {
            mainInput.focus();
        }
    }
});

// Add confirmation for bulk actions
function confirmBulkDelete() {
    return confirm('Are you sure you want to delete all completed tasks?');
}

// Auto-save functionality (for future enhancement)
function autoSave() {
    // This could be used for auto-saving drafts
    console.log('Auto-save functionality ready for implementation');
}

// Search functionality (for future enhancement)
function initializeSearch() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        let searchTimeout;
        searchInput.addEventListener('input', function() {
            clearTimeout(searchTimeout);
            searchTimeout = setTimeout(() => {
                filterTasks(this.value);
            }, 300);
        });
    }
}

function filterTasks(query) {
    const tasks = document.querySelectorAll('.todo-item');
    const lowerQuery = query.toLowerCase();
    
    tasks.forEach(task => {
        const taskText = task.querySelector('.task-text').textContent.toLowerCase();
        if (taskText.includes(lowerQuery)) {
            task.style.display = 'flex';
        } else {
            task.style.display = 'none';
        }
    });
}