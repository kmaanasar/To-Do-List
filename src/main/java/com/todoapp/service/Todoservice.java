package com.todoapp.service;

import com.todoapp.model.TodoItem;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class TodoService {
    private static final String DATA_FILE = System.getProperty("java.io.tmpdir") + File.separator + "todos.csv";
    private final List<TodoItem> todos;
    private int nextId;

    public TodoService() {
        this.todos = new ArrayList<>();
        this.nextId = 1;
        loadTodos();
    }

    public List<TodoItem> getAllTodos() {
        return new ArrayList<>(todos);
    }

    public List<TodoItem> getActiveTodos() {
        return todos.stream().filter(t -> !t.isCompleted()).collect(Collectors.toList());
    }

    public List<TodoItem> getCompletedTodos() {
        return todos.stream().filter(TodoItem::isCompleted).collect(Collectors.toList());
    }

    public TodoItem addTodo(String task, String priority) {
        if (task == null || task.trim().isEmpty()) return null;
        
        TodoItem todo = new TodoItem(nextId++, task.trim());
        if (priority != null && !priority.isEmpty()) {
            todo.setPriority(priority.toUpperCase());
        }
        todos.add(todo);
        saveTodos();
        return todo;
    }

    public boolean toggleComplete(int id) {
        TodoItem todo = findTodoById(id);
        if (todo != null) {
            todo.setCompleted(!todo.isCompleted());
            saveTodos();
            return true;
        }
        return false;
    }

    public boolean deleteTodo(int id) {
        TodoItem todo = findTodoById(id);
        if (todo != null) {
            todos.remove(todo);
            saveTodos();
            return true;
        }
        return false;
    }

    public boolean updateTodo(int id, String newTask, String priority) {
        TodoItem todo = findTodoById(id);
        if (todo != null) {
            if (newTask != null && !newTask.trim().isEmpty()) {
                todo.setTask(newTask.trim());
            }
            if (priority != null && !priority.isEmpty()) {
                todo.setPriority(priority.toUpperCase());
            }
            saveTodos();
            return true;
        }
        return false;
    }

    private TodoItem findTodoById(int id) {
        return todos.stream().filter(t -> t.getId() == id).findFirst().orElse(null);
    }

    private void loadTodos() {
        Path filePath = Paths.get(DATA_FILE);
        try {
            if (Files.exists(filePath)) {
                List<String> lines = Files.readAllLines(filePath);
                for (String line : lines) {
                    if (!line.trim().isEmpty()) {
                        TodoItem todo = TodoItem.fromString(line);
                        if (todo != null) {
                            todos.add(todo);
                            if (todo.getId() >= nextId) {
                                nextId = todo.getId() + 1;
                            }
                        }
                    }
                }
            } else {
                // Create the parent directories if they don't exist
                Files.createDirectories(filePath.getParent());
            }
        } catch (IOException e) {
            System.err.println("Error loading todos from: " + DATA_FILE);
            System.err.println("Error message: " + e.getMessage());
            // Don't fail completely, just continue with empty list
        }
    }

    private void saveTodos() {
        Path filePath = Paths.get(DATA_FILE);
        try {
            // Ensure parent directory exists
            Files.createDirectories(filePath.getParent());
            
            try (BufferedWriter writer = Files.newBufferedWriter(filePath)) {
                for (TodoItem todo : todos) {
                    writer.write(todo.toString());
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            System.err.println("Error saving todos to: " + DATA_FILE);
            System.err.println("Error message: " + e.getMessage());
        }
    }

    public int getTotalCount() { 
        return todos.size(); 
    }
    
    public int getActiveCount() { 
        return (int) todos.stream().filter(t -> !t.isCompleted()).count(); 
    }
    
    public int getCompletedCount() { 
        return (int) todos.stream().filter(TodoItem::isCompleted).count(); 
    }
}