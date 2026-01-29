<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Fuel Details | KMCH VMS</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
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
    top:0;
    left:0;
    width:250px;
    height:100vh;
    background:#111827;
    padding:20px 15px;
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

/* Table card */
.card-table{
    border-radius:16px;
    border:none;
    box-shadow:0 10px 25px rgba(0,0,0,0.06);
    background:#fff;
    padding:20px;
}

</style>
</head>

<body>

<%
String tripFile = "D:/car_data/trips.csv";
int index = Integer.parseInt(request.getParameter("index"));

BufferedReader br = new BufferedReader(new FileReader(tripFile));
String line;
int i = 0;
String[] t = null;

while((line = br.readLine()) != null){
    if(i == index){
        t = line.split(",");
        break;
    }
    i++;
}
br.close();
%>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <h4>KMCH VMS</h4>

    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp" class="active"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<!-- ===== MAIN CONTENT ===== -->
<div class="main-content">

<h4 class="mb-3 fw-semibold">Fuel Details</h4>

<div class="card-table">

<table class="table table-bordered">
<tr><th>Vehicle No</th><td><%=t[0]%></td></tr>
<tr><th>Start KM</th><td><%=t[4]%></td></tr>
<tr><th>End KM</th><td><%=t[5]%></td></tr>
<tr><th>Distance Travelled</th><td><%=t[6]%> KM</td></tr>
<tr><th>Fuel Used</th><td><%=t[7]%> Litres</td></tr>
<tr><th>Price / Litre</th><td>₹ <%=t[8]%></td></tr>
<tr><th>Mileage (KM/L)</th><td><%=t[9]%></td></tr>
<tr><th>Total Cost</th><td>₹ <%=t[10]%></td></tr>
</table>

<a href="viewTrip.jsp?vehicleNo=<%=t[0]%>" class="btn btn-primary mt-3">
    <i class="bi bi-arrow-left"></i> Back to Trips
</a>

</div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
