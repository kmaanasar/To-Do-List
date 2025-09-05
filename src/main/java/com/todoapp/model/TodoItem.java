package com.todoapp.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TodoItem {
    private int id;
    private String task;
    private boolean completed;
    private String createdAt;
    private String priority;

    public TodoItem() {
        this.createdAt = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        this.priority = "MEDIUM";
    }

    public TodoItem(int id, String task) {
        this();
        this.id = id;
        this.task = task;
        this.completed = false;
    }

    public TodoItem(int id, String task, boolean completed, String createdAt, String priority) {
        this.id = id;
        this.task = task;
        this.completed = completed;
        this.createdAt = createdAt;
        this.priority = priority != null ? priority : "MEDIUM";
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
    public void setPriority(String priority) { this.priority = priority; }

    @Override
    public String toString() {
        return id + "," + task.replace(",", "&#44;") + "," + completed + "," + createdAt + "," + priority;
    }

    public static TodoItem fromString(String str) {
        String[] parts = str.split(",", 5);
        if (parts.length >= 4) {
            int id = Integer.parseInt(parts[0]);
            String task = parts[1].replace("&#44;", ",");
            boolean completed = Boolean.parseBoolean(parts[2]);
            String createdAt = parts[3];
            String priority = parts.length > 4 ? parts[4] : "MEDIUM";
            return new TodoItem(id, task, completed, createdAt, priority);
        }
        return null;
    }
}