<%@ page import="java.io.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

String filePath = "D:/car_data/users.csv";
File file = new File(filePath);

boolean valid = false;

if(file.exists()){
    BufferedReader br = new BufferedReader(new FileReader(file));
    String line;
    boolean isFirstLine = true;

    while((line = br.readLine()) != null){
        if(isFirstLine){
            isFirstLine = false;
            continue;
        }

        if(line.trim().isEmpty()) continue;

        String[] data = line.split(",");
        if(data.length >= 3){
            String fileUser = data[1].trim();
            String filePass = data[2].trim();

            if(fileUser.equals(username.trim()) &&
               filePass.equals(password.trim())){
                valid = true;
                break;
            }
        }
    }
    br.close();
}

if(valid){
    session.setAttribute("user", username);
    response.sendRedirect("index.jsp");
}else{
    response.sendRedirect("login.jsp?error=1");
}
%>
