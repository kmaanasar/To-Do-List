package com.todoapp.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TodoItem {
    private int id;
    private String task;
    private boolean completed;
    private String createdAt;
    private String priority;

    private static final DateTimeFormatter FORMATTER =
            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public TodoItem() {
        this.createdAt = LocalDateTime.now().format(FORMATTER);
        this.priority = "MEDIUM";
        this.completed = false;
    }

    public TodoItem(int id, String task) {
        this();
        this.id = id;
        this.task = task;
    }

    public TodoItem(int id, String task, boolean completed, String createdAt, String priority) {
        this.id = id;
        this.task = task;
        this.completed = completed;
        this.createdAt = createdAt != null ? createdAt : LocalDateTime.now().format(FORMATTER);
        this.priority = (priority != null && !priority.isEmpty()) ? priority.toUpperCase() : "MEDIUM";
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTask() { return task; }
    public void setTask(String task) { this.task = task; }

    public boolean isCompleted() { return completed; }
    public void setCompleted(boolean completed) { this.completed = completed; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getPriority() { return priority; }
    public void setPriority(String priority) {
        if (priority != null && !priority.isEmpty()) {
            this.priority = priority.toUpperCase();
        }
    }

    @Override
    public String toString() {
        // escape commas in task to keep CSV stable
        return id + "," + (task == null ? "" : task.replace(",", "&#44;")) + "," + completed + "," + createdAt + "," + priority;
    }

    public static TodoItem fromString(String str) {
        if (str == null || str.trim().isEmpty()) return null;
        String[] parts = str.split(",", 5);
        try {
            if (parts.length >= 4) {
                int id = Integer.parseInt(parts[0]);
                String task = parts[1].replace("&#44;", ",");
                boolean completed = Boolean.parseBoolean(parts[2]);
                String createdAt = parts[3];
                String priority = (parts.length > 4 && parts[4] != null && !parts[4].isEmpty()) ? parts[4].toUpperCase() : "MEDIUM";
                return new TodoItem(id, task, completed, createdAt, priority);
            }
        } catch (Exception ignored) { }
        return null;
    }
}
