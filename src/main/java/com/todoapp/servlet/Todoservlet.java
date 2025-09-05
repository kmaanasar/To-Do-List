package com.todoapp.servlet;

import com.todoapp.model.TodoItem;
import com.todoapp.service.TodoService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/todos")
public class TodoServlet extends HttpServlet {
    private TodoService todoService;

    @Override
    public void init() throws ServletException {
        todoService = new TodoService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String filter = request.getParameter("filter");
        
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            todoService.deleteTodo(id);
            response.sendRedirect("todos");
            return;
        }
        
        if ("toggle".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            todoService.toggleComplete(id);
            response.sendRedirect("todos");
            return;
        }

        List<TodoItem> todos;
        if ("active".equals(filter)) {
            todos = todoService.getActiveTodos();
        } else if ("completed".equals(filter)) {
            todos = todoService.getCompletedTodos();
        } else {
            todos = todoService.getAllTodos();
        }

        request.setAttribute("todos", todos);
        request.setAttribute("filter", filter);
        request.setAttribute("totalCount", todoService.getTotalCount());
        request.setAttribute("activeCount", todoService.getActiveCount());
        request.setAttribute("completedCount", todoService.getCompletedCount());
        
        request.getRequestDispatcher("/WEB-INF/todo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            String task = request.getParameter("task");
            String priority = request.getParameter("priority");
            
            if (task != null && !task.trim().isEmpty()) {
                todoService.addTodo(task.trim(), priority);
            }
        }
        
        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String task = request.getParameter("task");
            String priority = request.getParameter("priority");
            
            if (task != null && !task.trim().isEmpty()) {
                todoService.updateTodo(id, task.trim(), priority);
            }
        }
        
        response.sendRedirect("todos");
    }
}