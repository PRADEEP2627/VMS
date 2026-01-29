<%@ page import="java.io.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("newPassword");

String filePath = "D:/car_data/users.csv";
File file = new File(filePath);

boolean exists = false;
int nextSno = 1;

if(!file.exists()){
    file.getParentFile().mkdirs();
    file.createNewFile();

    // Write header
    BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));
    bw.write("sno,username,password,date");
    bw.newLine();
    bw.close();
}

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
    if(data.length >= 2){
        nextSno = Integer.parseInt(data[0].trim()) + 1;

        if(data[1].trim().equalsIgnoreCase(username)){
            exists = true;
            break;
        }
    }
}
br.close();

if(exists){
    response.sendRedirect("register.jsp?error=1");
    return;
}

BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));
bw.write(nextSno + "," + username + "," + password + "," + new java.util.Date());
bw.newLine();
bw.close();

response.sendRedirect("login.jsp");
%>
