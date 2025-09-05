<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - Todo List App</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .error-container {
            max-width: 600px;
            margin: 50px auto;
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 2rem;
            color: #343a40;
            margin-bottom: 15px;
        }
        .error-message {
            color: #6c757d;
            font-size: 1.1rem;
            margin-bottom: 30px;
        }
        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .error-btn {
            padding: 12px 24px;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .error-btn-primary {
            background: #6c5ce7;
            color: white;
        }
        .error-btn-primary:hover {
            background: #5b4cdb;
            transform: translateY(-2px);
        }
        .error-btn-secondary {
            background: #6c757d;
            color: white;
        }
        .error-btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        .error-details {
            margin-top: 30px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
            color: #495057;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>

        <%
            // ✅ Use request attributes for error info
            Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
            String errorCode = (statusCode != null) ? String.valueOf(statusCode) : "Unknown";
            String errorTitle = "An Error Occurred";
            String errorMessage = "Something went wrong while processing your request.";

            if ("404".equals(errorCode)) {
                errorTitle = "Page Not Found";
                errorMessage = "The page you're looking for doesn't exist or has been moved.";
            } else if ("500".equals(errorCode)) {
                errorTitle = "Server Error";
                errorMessage = "There was an internal server error. Please try again later.";
            }
        %>

        <h1 class="error-title"><%= errorTitle %></h1>
        <p class="error-message"><%= errorMessage %></p>

        <div class="error-actions">
            <a href="../todos" class="error-btn error-btn-primary">Go to Todo List</a>
            <a href="javascript:history.back()" class="error-btn error-btn-secondary">Go Back</a>
        </div>

        <%
            Throwable exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
            if (exception != null) {
        %>
        <div class="error-details">
            <strong>Error Code:</strong> <%= errorCode %><br>
            <strong>Request URI:</strong> <%= request.getAttribute("javax.servlet.error.request_uri") %><br>
            <strong>Servlet Name:</strong> <%= request.getAttribute("javax.servlet.error.servlet_name") %><br>
            <strong>Exception:</strong> <%= exception %>
        </div>
        <% } %>
    </div>

    <script>
        // Auto redirect after 10 seconds if 404
        if ("<%= errorCode %>" === "404") {
            setTimeout(function() {
                if (confirm('Would you like to be redirected to the todo list?')) {
                    window.location.href = '../todos';
                }
            }, 10000);
        }
    </script>
</body>
</html>
