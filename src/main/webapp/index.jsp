<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redirect to the main todos page
    response.sendRedirect(request.getContextPath() + "/todos");
%>