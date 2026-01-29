<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Print Report</title>

<style>
body { font-family: Arial; font-size: 12px; }
h2 { text-align:center; }
table { width:100%; border-collapse: collapse; margin-top: 10px; }
th, td { border:1px solid #000; padding:6px; }
th { background:#eee; }

@media print {
    button { display:none; }
}
</style>

<script>
window.onload = function(){
    window.print();
}
</script>
</head>

<body>

<%
String type = request.getParameter("type");
String vehicle = request.getParameter("vehicle");
%>

<button onclick="window.print()">Print / Save as PDF</button>

<h2><%=type.toUpperCase()%> REPORT</h2>
<p><b>Vehicle:</b> <%=vehicle!=null?vehicle:"ALL"%></p>

<table>
<%
BufferedReader br;
String line;
int i=1;

/* VEHICLE */
if("vehicle".equals(type)){
%>
<tr><th>No</th><th>Vehicle No</th><th>Name</th><th>Owner</th></tr>
<%
br=new BufferedReader(new FileReader("D:/car_data/vehicles.txt"));
while((line=br.readLine())!=null){
String[] v=line.split(",");
%>
<tr>
<td><%=i++%></td>
<td><%=v[0]%></td>
<td><%=v[1]%></td>
<td><%=v[2]%></td>
</tr>
<% } br.close(); }

/* TRIP */
else if("trip".equals(type)){
%>
<tr><th>No</th><th>Vehicle</th><th>From</th><th>To</th><th>KM</th></tr>
<%
br=new BufferedReader(new FileReader("D:/car_data/trips.txt"));
while((line=br.readLine())!=null){
String[] t=line.split(",");
if(vehicle!=null && !vehicle.equals("") && !t[0].equals(vehicle)) continue;
%>
<tr>
<td><%=i++%></td>
<td><%=t[0]%></td>
<td><%=t[1]%></td>
<td><%=t[2]%></td>
<td><%=t[3]%></td>
</tr>
<% } br.close(); }

/* SERVICE */
else if("service".equals(type)){
%>
<tr><th>No</th><th>Vehicle</th><th>Date</th><th>Type</th><th>Cost</th></tr>
<%
br=new BufferedReader(new FileReader("D:/car_data/services.txt"));
while((line=br.readLine())!=null){
String[] s=line.split(",");
if(vehicle!=null && !vehicle.equals("") && !s[0].equals(vehicle)) continue;
%>
<tr>
<td><%=i++%></td>
<td><%=s[0]%></td>
<td><%=s[1]%></td>
<td><%=s[2]%></td>
<td>₹ <%=s[5]%></td>
</tr>
<% } br.close(); }
%>
</table>

</body>
</html>
