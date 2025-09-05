package com.todoapp.service;

import com.todoapp.model.TodoItem;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class TodoService {
    private static final String DATA_FILE = "todos.csv";
    private List<TodoItem> todos;
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
        return todos.stream()
                .filter(todo -> !todo.isCompleted())
                .collect(Collectors.toList());
    }

    public List<TodoItem> getCompletedTodos() {
        return todos.stream()
                .filter(TodoItem::isCompleted)
                .collect(Collectors.toList());
    }

    public TodoItem addTodo(String task, String priority) {
        TodoItem todo = new TodoItem(nextId++, task);
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
            todo.setTask(newTask);
            if (priority != null && !priority.isEmpty()) {
                todo.setPriority(priority.toUpperCase());
            }
            saveTodos();
            return true;
        }
        return false;
    }

    private TodoItem findTodoById(int id) {
        return todos.stream()
                .filter(todo -> todo.getId() == id)
                .findFirst()
                .orElse(null);
    }

    private void loadTodos() {
        try {
            if (Files.exists(Paths.get(DATA_FILE))) {
                List<String> lines = Files.readAllLines(Paths.get(DATA_FILE));
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
            }
        } catch (IOException e) {
            System.err.println("Error loading todos: " + e.getMessage());
        }
    }

    private void saveTodos() {
        try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(DATA_FILE))) {
            for (TodoItem todo : todos) {
                writer.write(todo.toString());
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error saving todos: " + e.getMessage());
        }
    }

    public int getTotalCount() {
        return todos.size();
    }

    public int getActiveCount() {
        return (int) todos.stream().filter(todo -> !todo.isCompleted()).count();
    }

    public int getCompletedCount() {
        return (int) todos.stream().filter(TodoItem::isCompleted).count();
    }
}