<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reports | KMCH VMS</title>

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

<style>
body{
    margin:0;
    background:#f4f6f9;
    font-family: system-ui, -apple-system, "Segoe UI", Roboto;
}

/* ===== Sidebar ===== */
.sidebar{
    position:fixed;
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

/* ===== Main Content ===== */
.main-content{
    margin-left:250px;
    padding:30px;
}

/* ===== Cards ===== */
.card{
    border-radius:16px;
}

/* ===== Header Actions ===== */
.header-actions{
    display:flex;
    justify-content:space-between;
    align-items:center;
}

/* ===== Download hover colors ===== */
.dropdown-item{
    transition:all .3s ease;
    font-weight:500;
}

.dropdown-item.txt-item:hover{
    background:#2563eb;
    color:#fff;
}

.dropdown-item.excel-item:hover{
    background:#16a34a;
    color:#fff;
}
.sidebar .logout-link:hover{background:#dc2626;}

.dropdown-item.pdf-item:hover{
    background:#dc2626;
    color:#fff;
}
</style>
</head>

<body>

<%
String type = request.getParameter("type");
String vehicle = request.getParameter("vehicle");
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
%>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <h4>KMCH VMS</h4>

    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp" class="active"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<!-- ===== MAIN CONTENT ===== -->
<div class="main-content">

<h4 class="fw-semibold mb-4">Reports</h4>

<!-- ===== FILTER CARD ===== -->
<div class="card shadow-sm p-4 mb-4">
<form method="get" class="row g-3">

<div class="col-md-4">
<label class="form-label">Report Type</label>
<select name="type" class="form-select" onchange="this.form.submit()">
<option value="">-- Select --</option>
<option value="vehicle" <%= "vehicle".equals(type)?"selected":"" %>>Vehicle Details</option>
<option value="trip" <%= "trip".equals(type)?"selected":"" %>>Trips</option>
<option value="service" <%= "service".equals(type)?"selected":"" %>>Service</option>
<option value="fuel" <%= "fuel".equals(type)?"selected":"" %>>Fuel</option>
</select>
</div>

<% if("trip".equals(type) || "service".equals(type) || "fuel".equals(type)){ %>
<div class="col-md-4">
<label class="form-label">Vehicle</label>
<select name="vehicle" class="form-select" onchange="this.form.submit()">
<option value="">-- Select Vehicle --</option>
<%
BufferedReader vbr = new BufferedReader(new FileReader("D:/car_data/vehicles.txt"));
String vline;
while((vline = vbr.readLine()) != null){
    String[] v = vline.split(",");
%>
<option value="<%=v[0]%>" <%= v[0].equals(vehicle)?"selected":"" %>>
    <%=v[0]%>
</option>
<% } vbr.close(); %>
</select>
</div>
<% } %>

<% if("trip".equals(type)){ %>
<div class="col-md-2">
<label class="form-label">From Date</label>
<input type="date" name="fromDate" class="form-control" value="<%=fromDate!=null?fromDate:""%>">
</div>
<div class="col-md-2">
<label class="form-label">To Date</label>
<input type="date" name="toDate" class="form-control" value="<%=toDate!=null?toDate:""%>">
</div>
<% } %>

</form>
</div>

<% if(type!=null && !type.equals("")){ %>

<!-- ===== REPORT HEADER ===== -->
<div class="header-actions mb-3">
<h5 class="mb-0 text-capitalize"><%=type%> Report</h5>

<div class="dropdown">
<button class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown">
<i class="bi bi-download"></i> Download
</button>
<ul class="dropdown-menu dropdown-menu-end shadow">
<li><a class="dropdown-item txt-item"
href="downloadReport.jsp?type=<%=type%>&vehicle=<%=vehicle%>&format=txt">TXT</a></li>
<li><a class="dropdown-item excel-item"
href="downloadReport.jsp?type=<%=type%>&vehicle=<%=vehicle%>&format=excel">Excel</a></li>
<li><a class="dropdown-item pdf-item"
href="downloadReportPdf.jsp?type=<%=type%>&vehicle=<%=vehicle%>">PDF</a></li>
</ul>
</div>
</div>

<!-- ===== VEHICLE REPORT ===== -->
<% if("vehicle".equals(type)){ %>
<div class="card shadow-sm p-3">
<table class="table table-bordered table-striped align-middle">
<thead class="table-dark">
<tr><th>#</th><th>Vehicle No</th><th>Name</th><th>Owner</th></tr>
</thead>
<tbody>
<%
int i=1;
BufferedReader br = new BufferedReader(new FileReader("D:/car_data/vehicles.txt"));
String l;
while((l=br.readLine())!=null){
String[] v=l.split(",");
%>
<tr>
<td><%=i++%></td>
<td><%=v[0]%></td>
<td><%=v[1]%></td>
<td><%=v[2]%></td>
</tr>
<% } br.close(); %>
</tbody>
</table>
</div>
<% } %>

<!-- ===== TRIP REPORT ===== -->
<% if("trip".equals(type)){ %>
<% if(vehicle==null || vehicle.equals("")){ %>
<p class="text-muted">Please select a vehicle</p>
<% } else { %>
<div class="card shadow-sm p-3">
<table class="table table-bordered table-striped align-middle">
<thead class="table-dark">
<tr><th>#</th><th>From</th><th>To</th><th>KM</th></tr>
</thead>
<tbody>
<%
int i=1;
BufferedReader br = new BufferedReader(new FileReader("D:/car_data/trips.txt"));
String t;
while((t=br.readLine())!=null){
String[] s=t.split(",");
if(s[0].equals(vehicle)){
%>
<tr>
<td><%=i++%></td>
<td><%=s[1]%></td>
<td><%=s[2]%></td>
<td><%=s[3]%></td>
</tr>
<% }} br.close(); %>
</tbody>
</table>
</div>
<% } %>
<% } %>

<!-- ===== SERVICE REPORT ===== -->
<% if("service".equals(type)){ %>
<% if(vehicle==null || vehicle.equals("")){ %>
<p class="text-muted">Please select a vehicle</p>
<% } else { %>
<div class="card shadow-sm p-3">
<table class="table table-bordered table-striped align-middle">
<thead class="table-dark">
<tr><th>#</th><th>Date</th><th>Type</th><th>Cost</th></tr>
</thead>
<tbody>
<%
int i=1;
BufferedReader br = new BufferedReader(new FileReader("D:/car_data/services.txt"));
String s;
while((s=br.readLine())!=null){
String[] a=s.split(",");
if(a[0].equals(vehicle)){
%>
<tr>
<td><%=i++%></td>
<td><%=a[1]%></td>
<td><%=a[2]%></td>
<td>₹ <%=a[5]%></td>
</tr>
<% }} br.close(); %>
</tbody>
</table>
</div>
<% } %>
<% } %>

<!-- ===== FUEL REPORT ===== -->
<% if("fuel".equals(type)){ %>
<% if(vehicle==null || vehicle.equals("")){ %>
<p class="text-muted">Please select a vehicle</p>
<% } else { %>
<div class="card shadow-sm p-3">
<table class="table table-bordered table-striped align-middle">
<thead class="table-dark">
<tr><th>#</th><th>Litres</th><th>Price</th><th>Total</th></tr>
</thead>
<tbody>
<%
int i=1;
BufferedReader br = new BufferedReader(new FileReader("D:/car_data/trips.txt"));
String f;
while((f=br.readLine())!=null){
String[] a=f.split(",");
if(a[0].equals(vehicle)){
%>
<tr>
<td><%=i++%></td>
<td><%=a[7]%></td>
<td><%=a[8]%></td>
<td>₹ <%=a[10]%></td>
</tr>
<% }} br.close(); %>
</tbody>
</table>
</div>
<% } %>
<% } %>

<% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
