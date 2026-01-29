<%@ page import="java.io.*,java.util.*" %>

<%
String type = request.getParameter("type");

String vehicleFile="D:/car_data/vehicles.txt";
String tripFile="D:/car_data/trips.txt";
String serviceFile="D:/car_data/services.txt";
%>

<table class="table table-bordered table-striped">
<thead class="table-dark">
<tr>

<% if("vehicle".equals(type)){ %>
<th>#</th><th>Vehicle No</th><th>Name</th><th>Owner</th>

<% } else if("trip".equals(type)){ %>
<th>Vehicle No</th><th>Total Trips</th>

<% } else if("service".equals(type)){ %>
<th>Vehicle No</th><th>Total Services</th>

<% } else if("fuel".equals(type)){ %>
<th>Vehicle No</th><th>Total Fuel Cost (₹)</th>
<% } %>

</tr>
</thead>
<tbody>

<%
if("vehicle".equals(type)){
int i=1;
BufferedReader br=new BufferedReader(new FileReader(vehicleFile));
String l;
while((l=br.readLine())!=null){
String[] v=l.split(",");
%>
<tr><td><%=i++%></td><td><%=v[0]%></td><td><%=v[1]%></td><td><%=v[2]%></td></tr>
<%
}
br.close();
}

else if("trip".equals(type)){
Map<String,Integer> map=new HashMap<>();
BufferedReader br=new BufferedReader(new FileReader(tripFile));
String l;
while((l=br.readLine())!=null){
String[] t=l.split(",");
map.put(t[0], map.getOrDefault(t[0],0)+1);
}
br.close();
for(String v:map.keySet()){
%>
<tr><td><%=v%></td><td><%=map.get(v)%></td></tr>
<% }
}

else if("service".equals(type)){
Map<String,Integer> map=new HashMap<>();
BufferedReader br=new BufferedReader(new FileReader(serviceFile));
String l;
while((l=br.readLine())!=null){
String[] s=l.split(",");
map.put(s[0], map.getOrDefault(s[0],0)+1);
}
br.close();
for(String v:map.keySet()){
%>
<tr><td><%=v%></td><td><%=map.get(v)%></td></tr>
<% }
}

else if("fuel".equals(type)){
Map<String,Double> map=new HashMap<>();
BufferedReader br=new BufferedReader(new FileReader(tripFile));
String l;
while((l=br.readLine())!=null){
String[] t=l.split(",");
map.put(t[0], map.getOrDefault(t[0],0.0)+Double.parseDouble(t[10]));
}
br.close();
for(String v:map.keySet()){
%>
<tr><td><%=v%></td><td>₹ <%=map.get(v)%></td></tr>
<% }
}
%>

</tbody>
</table>

<a href="downloadReport.jsp?type=<%=type%>&format=txt" class="btn btn-secondary">TXT</a>
<a href="downloadReport.jsp?type=<%=type%>&format=excel" class="btn btn-success">Excel</a>
<a href="downloadReportPdf.jsp?type=<%=type%>" class="btn btn-danger">PDF</a>
