<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>

<%
String filePath = "D:/car_data/vehicles.txt";

int delIndex = -1;
try{
    delIndex = Integer.parseInt(request.getParameter("index"));
}catch(Exception e){
    response.sendRedirect("viewVehicle.jsp");
    return;
}

File file = new File(filePath);
if(!file.exists()){
    response.sendRedirect("viewVehicle.jsp");
    return;
}

List<String> lines = new ArrayList<>();

BufferedReader br = new BufferedReader(new FileReader(file));
String line;
while((line = br.readLine()) != null){
    lines.add(line);
}
br.close();

if(delIndex >= 0 && delIndex < lines.size()){
    lines.remove(delIndex);

    BufferedWriter bw = new BufferedWriter(new FileWriter(file));
    for(String l : lines){
        bw.write(l);
        bw.newLine();
    }
    bw.close();
}

response.sendRedirect("viewVehicle.jsp");
%>
