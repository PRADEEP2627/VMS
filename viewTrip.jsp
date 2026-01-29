<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, java.util.*" %>

<%!
class Trip {
    int csvIndex;
    String vehicleNo;
    String from;
    String to;
    double distance;
    double cost;

    Trip(int csvIndex, String vehicleNo, String from, String to, double distance, double cost) {
        this.csvIndex = csvIndex;
        this.vehicleNo = vehicleNo;
        this.from = from;
        this.to = to;
        this.distance = distance;
        this.cost = cost;
    }
}
%>

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
String tripFile = "D:/car_data/trips.csv";

List<Trip> tripsList = new ArrayList<>();

BufferedReader br = new BufferedReader(new FileReader(tripFile));
String line;
int csvIndex = 0;

while((line = br.readLine()) != null){
    if(line.trim().isEmpty()){
        csvIndex++;
        continue;
    }

    String[] t = line.split(",", -1);
    if(t.length < 11){
        csvIndex++;
        continue;
    }

    String vehicleNo = t[0];

    if(selectedVehicle != null && !selectedVehicle.isEmpty()
            && !vehicleNo.equals(selectedVehicle)){
        csvIndex++;
        continue;
    }

    double distance = 0, cost = 0;
    try{ distance = Double.parseDouble(t[3]); }catch(Exception e){}
    try{ cost = Double.parseDouble(t[10]); }catch(Exception e){}

    tripsList.add(new Trip(
        csvIndex, vehicleNo, t[1], t[2], distance, cost
    ));

    csvIndex++;
}
br.close();
%>

<!DOCTYPE html>
<html>
<head>
<title>Trip Details | KMCH VMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
/* ===== Base ===== */
body{
    margin:0;
    background:#f4f6f9;
    font-family: system-ui, -apple-system, "Segoe UI", Roboto;
}

/* ===== Sidebar ===== */
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
    transition:all 0.25s ease;
}

/* Hover + Active */
.sidebar a:hover,
.sidebar a.active {
    /* Use Total Vehicles card gradient */
    background: linear-gradient(135deg, #38bdf8, #2563eb);
    color: #fff; /* white text for contrast */
    font-weight:600;
}


.sidebar i{
    font-size:18px;
}

/* ===== Content ===== */
.main-content{
    margin-left:250px;
    padding:30px;
}
.sidebar .logout-link:hover{background:#dc2626;}


.vehicle-card{
    background: #ffffff;
     width: 90%; 
    padding: 14px 12px;
    border-radius: 12px;
    display: block;
    margin-bottom: 10px;
    text-decoration: none;
    color: #111;
    box-shadow: 0 6px 18px rgba(0,0,0,.06);
    transition: all 0.2s ease;
}

.vehicle-card:hover{
    background: #e9f1ff;
    color: #111;
}

/* Vehicle name */
.vehicle-name{
    color: #6c757d;
    font-size: 13px;
}

/* ACTIVE STATE */
.vehicle-card.active{
     background: linear-gradient(135deg, #38bdf8, #2563eb);
    color: #fff; /* white text for contrast */
    font-weight:600;
}

.vehicle-card.active .vehicle-name{
    color: #e6ecff;
}




.table td,.table th{text-align:center;vertical-align:middle;}
.action-btn{min-width:80px;border-radius:10px;font-size:.85rem;}
</style>
</head>

<body>

<div class="sidebar">
    <h4>KMCH VMS</h4>

    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp" ><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"class="active"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<div class="main-content">
<h4 class="mb-3">Trip Details</h4>

<div class="row">

<div class="col-md-3">

<!-- All Vehicles -->
<a href="viewTrip.jsp"
   class="vehicle-card fw-bold <%= (selectedVehicle == null) ? "active" : "" %>">
   All Vehicles
</a>

<%
BufferedReader vbr = new BufferedReader(new FileReader(vehicleFile));
while((line = vbr.readLine()) != null){
    if(line.trim().isEmpty()) continue;

    String[] v = line.split(",", -1);
    String vNo   = v[0];
    String vName = v.length > 1 ? v[1] : "";

    boolean active = vNo.equals(selectedVehicle);
%>

<a href="viewTrip.jsp?vehicleNo=<%=vNo%>"
   class="vehicle-card <%= active ? "active" : "" %>">

    <b><%=vNo%></b><br>
    <small class="text-muted <%= active ? "text-white" : "" %>">
        <%=vName%>
    </small>

</a>

<%
}
vbr.close();
%>

</div>



<!-- TRIP TABLE -->
<div class="col-md-9">
<div class="card p-3">
<table class="table table-bordered table-hover">
<thead class="table-dark">
<tr>
    <th>Vehicle</th>
    <th>From</th>
    <th>To</th>
    <th>Total Distance</th>
    <th>Total Cost</th>
    <th>Actions</th>
</tr>
</thead>
<tbody>

<%
if(tripsList.isEmpty()){
%>
<tr><td colspan="6" class="text-center">No trips found</td></tr>
<%
}

for(Trip t:tripsList){
%>
<tr>
    <td><%=t.vehicleNo%></td>
    <td><%=t.from%></td>
    <td><%=t.to%></td>
    <td><%=String.format("%.2f",t.distance)%></td>
    <td>₹ <%=String.format("%.2f",t.cost)%></td>
    <td>
        <a href="editTrip.jsp?index=<%=t.csvIndex%>&vehicleNo=<%=t.vehicleNo%>"
           class="btn btn-primary btn-sm action-btn">
           <i class="bi bi-pencil"></i> Edit
        </a>
        <a href="fuelDetails.jsp?index=<%=t.csvIndex%>"
           class="btn btn-danger btn-sm action-btn">
           <i class="bi bi-fuel-pump"></i> Fuel
        </a>
    </td>
</tr>
<%
}
%>

</tbody>
</table>
</div>
</div>

</div>
</div>

</body>
</html>
