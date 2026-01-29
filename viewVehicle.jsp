<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, java.util.*" %>

<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

if(session.getAttribute("user")==null){
    response.sendRedirect("login.jsp");
    return;
}

String selectedVehicle = request.getParameter("vehicleNo");
String vehicleFile = "D:/car_data/vehicles.csv";

/* Read vehicles */
class Vehicle {
    int index;
    String no;
    String name;
    String fuel;

    Vehicle(int index,String no,String name,String fuel){
        this.index=index;
        this.no=no;
        this.name=name;
        this.fuel=fuel;
    }
}

List<Vehicle> vehicleList = new ArrayList<>();

BufferedReader br = new BufferedReader(new FileReader(vehicleFile));
String line;
int idx = 0;

while((line = br.readLine()) != null){
    if(line.trim().isEmpty()){
        idx++;
        continue;
    }
    String[] v = line.split(",", -1);
    vehicleList.add(new Vehicle(
        idx,
        v[0],
        v.length>1?v[1]:"",
        v.length>2?v[2]:""
    ));
    idx++;
}
br.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>Vehicle Details | KMCH VMS</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
body{
    margin:0;
    background:#f4f6f9;
    font-family: system-ui, -apple-system, "Segoe UI", Roboto;
}

/* Sidebar */
.sidebar{
    position: fixed;
    top: 0;
    left: 0;
    width: 250px;
    height: 100vh;
    background: #111827;
    padding: 20px 15px;
}
.sidebar h4{
    color:#fff;
    text-align:center;
    font-weight:600;
    margin-bottom:25px;
}

.sidebar a{
    display:flex;
    align-items:center;
    gap:12px;
    padding:12px 15px;
    margin-bottom:8px;
    color:#cbd5e1;
    text-decoration:none;
    border-radius:10px;
    font-weight:500;
}
.sidebar a:hover,
.sidebar a.active{
    background:linear-gradient(135deg,#38bdf8,#2563eb);
    color:#fff;
}
.sidebar .logout-link:hover{background:#dc2626}

.sidebar i{
    font-size:18px;
}
/* Content */
.main-content{
    margin-left:250px;
    padding:30px;
}

/* Vehicle Cards */
.vehicle-card{
    background:#fff;
    width:90%;
    padding:14px 12px;
    border-radius:12px;
    margin-bottom:10px;
    text-decoration:none;
    color:#111;
    display:block;
    box-shadow:0 6px 18px rgba(0,0,0,.06);
}
.vehicle-card:hover{background:#e9f1ff}

.vehicle-card.active{
    background:linear-gradient(135deg,#38bdf8,#2563eb);
    color:#fff;
    font-weight:600;
}
.vehicle-card.active .vehicle-name{color:#e6ecff}

.vehicle-name{
    font-size:13px;
    color:#6c757d;
}

/* Table */
.table td,.table th{
    text-align:center;
    vertical-align:middle;
}
.action-btn{
    min-width:80px;
    border-radius:10px;
    font-size:.85rem;
}
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4>KMCH VMS</h4>
    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp" class="active"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<!-- CONTENT -->
<div class="main-content">
<h4 class="mb-3">Vehicle Details</h4>

<div class="row">

<!-- LEFT : VEHICLE LIST -->
<div class="col-md-3">

<a href="viewVehicle.jsp"
   class="vehicle-card fw-bold <%= selectedVehicle==null?"active":"" %>">
   All Vehicles
</a>

<% for(Vehicle v:vehicleList){ 
    boolean active = v.no.equals(selectedVehicle);
%>

<a href="viewVehicle.jsp?vehicleNo=<%=v.no%>"
   class="vehicle-card <%=active?"active":""%>">
   <b><%=v.no%></b><br>
   <small class="vehicle-name"><%=v.name%></small>
</a>

<% } %>

</div>

<!-- RIGHT : VEHICLE DETAILS -->
<div class="col-md-9">
<div class="card p-3">

<table class="table table-bordered table-hover">
<thead class="table-dark">
<tr>
    <th>Vehicle No</th>
    <th>Name</th>
    <th>Fuel</th>
    <th>Actions</th>
</tr>
</thead>
<tbody>

<%
boolean found = false;
for(Vehicle v:vehicleList){
    if(selectedVehicle!=null && !selectedVehicle.equals(v.no)) continue;
    found = true;
%>

<tr>
    <td><%=v.no%></td>
    <td><%=v.name%></td>
    <td><%=v.fuel%></td>
    <td>
        <a href="editVehicle.jsp?row=<%=v.index%>"
           class="btn btn-primary btn-sm action-btn">
           <i class="bi bi-pencil"></i> Edit
        </a>
        <a href="deleteVehicle.jsp?row=<%=v.index%>"
           onclick="return confirm('Delete this vehicle?');"
           class="btn btn-danger btn-sm action-btn">
           <i class="bi bi-trash"></i> Delete
        </a>
    </td>
</tr>

<% } %>

<% if(!found){ %>
<tr><td colspan="4">No vehicles found</td></tr>
<% } %>

</tbody>
</table>

</div>
</div>

</div>
</div>

</body>
</html>
