<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, java.util.*, java.text.*" %>

<%
if(session.getAttribute("user")==null){
    response.sendRedirect("login.jsp");
    return;
}

String selectedVehicle = request.getParameter("vehicleNo");
String view = request.getParameter("view");
if(view == null) view = "service";
%>

<!DOCTYPE html>
<html>
<head>
<title>Service & Document | KMCH VMS</title>

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
    padding: 14px 16px;
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

.card{border-radius:16px;box-shadow:0 10px 30px rgba(0,0,0,.06)}
.btn-service{background:#0d6efd;color:#fff}
.btn-document{background:#fd7e14;color:#fff}
.status-badge{padding:4px 10px;border-radius:12px;color:#fff;font-size:.8rem}
.badge-active{background:#22c55e}
.badge-expired{background:#ef4444}
</style>
</head>

<body>

<div class="sidebar">
    <h4>KMCH VMS</h4>
    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp" class="active"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<div class="main-content">
<h4 class="fw-semibold mb-3">Service & Document Details</h4>

<div class="row">

<!-- VEHICLE LIST -->
<div class="col-md-3">
<h6 class="fw-semibold mb-2">Vehicles</h6>

<!-- All Vehicles -->
<a href="viewService.jsp?view=<%=view%>"
   class="vehicle-card fw-semibold <%= (selectedVehicle == null) ? "active" : "" %>">
   All Vehicles
</a>

<%
File vf = new File("D:/car_data/vehicles.csv");
if(vf.exists()){
    BufferedReader vbr = new BufferedReader(new FileReader(vf));
    String line;
    while((line=vbr.readLine())!=null){
        if(line.trim().isEmpty()) continue;
        String[] v = line.split(",", -1);
        String vNo = v[0];
        String vName = v.length > 1 ? v[1] : "";

        boolean active = vNo.equals(selectedVehicle);
%>

<a href="viewService.jsp?vehicleNo=<%=vNo%>&view=<%=view%>"
   class="vehicle-card <%= active ? "active" : "" %>">
    <b><%=vNo%></b><br>
    <small class="text-muted <%= active ? "text-white" : "" %>">
        <%=vName%>
    </small>
</a>

<%
    }
    vbr.close();
}
%>
</div>


<!-- RIGHT CONTENT -->
<div class="col-md-9">

<div class="row mb-3">
<div class="col-md-3">
<button class="btn btn-service w-100"
onclick="location.href='viewService.jsp?vehicleNo=<%=selectedVehicle%>&view=service'">
Service
</button>
</div>
<div class="col-md-3">
<button class="btn btn-document w-100"
onclick="location.href='viewService.jsp?vehicleNo=<%=selectedVehicle%>&view=document'">
Document
</button>
</div>
</div>

<div class="card p-3">
<table class="table table-bordered align-middle">
<thead class="table-dark">
<tr>
<th>Name</th>
<th>Start Date</th>
<th>End Date</th>
<th>Details</th>
<th>Status</th>
</tr>
</thead>

<tbody>

<%
if(selectedVehicle!=null && !selectedVehicle.isEmpty()){

File file = view.equals("service")
    ? new File("D:/car_data/services.csv")
    : new File("D:/car_data/vehicle_documents.csv");

if(file.exists()){
BufferedReader br=new BufferedReader(new FileReader(file));
String line;

Date today=new Date();
SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd");

while((line=br.readLine())!=null){
    if(line.trim().isEmpty()) continue;

    String[] d=line.split(",",-1);
    if(d.length<4) continue;
    if(!selectedVehicle.equals(d[0])) continue;

    String endDateStr=d[3];
    String status="Active", badge="badge-active";

    try{
        if(endDateStr!=null && !endDateStr.isEmpty()){
            Date end=df.parse(endDateStr);
            if(end.before(today)){
                status="Expired";
                badge="badge-expired";
            }
        }
    }catch(Exception e){}
%>

<tr>
<td><b><%=d[1]%></b></td>
<td><%=d[2]%></td>
<td><%=d[3]%></td>
<td class="small">
<% if(view.equals("service")){ %>
KM: <%=d[4]%> | Cost: ₹ <%=d[5]%>
<% } else { %>
Document Validity
<% } %>
</td>
<td><span class="status-badge <%=badge%>"><%=status%></span></td>
</tr>

<%
}
br.close();
}
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
