<%@ page import="java.io.*" %>
<%
String tripFile = "D:/car_data/trips.txt";

int deleteIndex = Integer.parseInt(request.getParameter("index"));
String vehicleNo = request.getParameter("vehicleNo");

BufferedReader br = new BufferedReader(new FileReader(tripFile));
StringBuilder sb = new StringBuilder();
String line;
int i = 0;

while ((line = br.readLine()) != null) {
    if (i != deleteIndex) {
        sb.append(line).append("\n");
    }
    i++;
}
br.close();

BufferedWriter bw = new BufferedWriter(new FileWriter(tripFile));
bw.write(sb.toString());
bw.close();

/* Redirect back with filter */
if(vehicleNo != null && !vehicleNo.equals("null")){
    response.sendRedirect("viewTrip.jsp?vehicleNo=" + vehicleNo);
} else {
    response.sendRedirect("viewTrip.jsp");
}
%>
