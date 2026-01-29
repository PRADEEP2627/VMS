<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.text.*" %>

<%
/* ===== SESSION CHECK ===== */
if(session.getAttribute("user")==null){
    response.sendRedirect("login.jsp");
    return;
}

/* ===== FILE PATHS ===== */
String vehicleFile="D:/car_data/vehicles.csv";
String tripFile="D:/car_data/trips.csv";
String serviceFile="D:/car_data/services.csv";

/* ===== DASHBOARD COUNTS ===== */
int totalVehicles=0,totalTrips=0;
double totalFuelCost=0;

int activeServices = 0;
int expiredServices = 0;

int activeDocuments = 0;
int expiredDocuments = 0;


/* ===== MAPS ===== */
Map<String,Integer> tripCount=new LinkedHashMap<>();
Map<String,Double> fuelCostMap=new LinkedHashMap<>();

/* ===== READ VEHICLES ===== */
if(new File(vehicleFile).exists()){
    BufferedReader br=new BufferedReader(new FileReader(vehicleFile));
    String line;
    while((line=br.readLine())!=null){
        if(line.trim().isEmpty()) continue;
        String[] v=line.split(",",-1);
        if(v.length<2) continue;

        String vehicleNo=v[0]; // Vehicle No (consistent everywhere)
        totalVehicles++;
        tripCount.put(vehicleNo,0);
        fuelCostMap.put(vehicleNo,0.0);
    }
    br.close();
}

/* ===== READ TRIPS ===== */
if(new File(tripFile).exists()){
    BufferedReader br=new BufferedReader(new FileReader(tripFile));
    String line;
    while((line=br.readLine())!=null){
        if(line.trim().isEmpty()) continue;
        String[] t=line.split(",",-1);
        if(t.length<11) continue;

        String vehicleNo=t[0];
        double cost=0;
        try{ cost=Double.parseDouble(t[10]); }catch(Exception e){}

        if(tripCount.containsKey(vehicleNo)){
            tripCount.put(vehicleNo,tripCount.get(vehicleNo)+1);
            fuelCostMap.put(vehicleNo,fuelCostMap.get(vehicleNo)+cost);
            totalTrips++;
            totalFuelCost+=cost;
        }
    }
    br.close();
}

/* ===== SERVICES ===== */
File serviceFileObj = new File("D:/car_data/services.csv");
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
Date today = new Date();

if(serviceFileObj.exists()){
    BufferedReader br = new BufferedReader(new FileReader(serviceFileObj));
    String line;
    while((line = br.readLine()) != null){
        if(line.trim().isEmpty()) continue;
        String[] s = line.split(",", -1);
        if(s.length < 4) continue;

        try{
            Date endDate = sdf.parse(s[3]);
            if(endDate.before(today)) expiredServices++;
            else activeServices++;
        }catch(Exception e){
            activeServices++;
        }
    }
    br.close();
}
/* ===== DOCUMENTS ===== */
File docFileObj = new File("D:/car_data/vehicle_documents.csv");

if(docFileObj.exists()){
    BufferedReader br = new BufferedReader(new FileReader(docFileObj));
    String line;
    while((line = br.readLine()) != null){
        if(line.trim().isEmpty()) continue;
        String[] d = line.split(",", -1);
        if(d.length < 4) continue;

        try{
            Date endDate = sdf.parse(d[3]);
            if(endDate.before(today)) expiredDocuments++;
            else activeDocuments++;
        }catch(Exception e){
            activeDocuments++;
        }
    }
    br.close();
}


/* ===== CHART DATA ===== */
StringBuilder labels=new StringBuilder();
StringBuilder tripData=new StringBuilder();
StringBuilder costData=new StringBuilder();

for(String v:tripCount.keySet()){
    labels.append("'").append(v).append("',");
    tripData.append(tripCount.get(v)).append(",");
    costData.append(fuelCostMap.get(v)).append(",");
}
if(labels.length()>0){
    labels.setLength(labels.length()-1);
    tripData.setLength(tripData.length()-1);
    costData.setLength(costData.length()-1);
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>KMCH VMS | Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
.dashboard-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}
/* ===== Dashboard New UI ===== */
.kpi-ui{
    color:#fff;
    border-radius:18px;
}
.kpi-ui .card-body{padding:22px}
.kpi-icon{
    font-size:28px;
    opacity:.9;
    margin-bottom:8px;
}
.total{background:linear-gradient(135deg,#3b82f6,#2563eb)}
.success{background:linear-gradient(135deg,#16a34a,#4ade80)}
.danger{background:linear-gradient(135deg,#dc2626,#f87171)}
.warning{background:linear-gradient(135deg,#f59e0b,#fbbf24)}
.primary{background:linear-gradient(135deg,#6366f1,#4f46e5)}


.card-header{
    border-bottom:1px solid #eef2f7;
}

</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
<h4>KMCH VMS</h4>
<a class="active" href="index.jsp"><i class="bi bi-speedometer2"></i>Dashboard</a>
<a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i>Add Vehicle</a>
<a href="viewVehicle.jsp"><i class="bi bi-car-front"></i>View Vehicles</a>
<a href="addTrip.jsp"><i class="bi bi-geo-alt"></i>Add Trip</a>
<a href="viewTrip.jsp"><i class="bi bi-map"></i>Trip Details</a>
<a href="addService.jsp"><i class="bi bi-tools"></i>Add Service</a>
<a href="viewService.jsp"><i class="bi bi-clipboard-check"></i>Service Details</a>
<a href="report.jsp"><i class="bi bi-bar-chart"></i>Reports</a>
<a href="logout.jsp" class="logout-link">Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="main-content">

<!-- PAGE HEADER -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h4 class="fw-bold mb-1">Dashboard</h4>
        <small class="text-muted">Vehicle & Trip Monitoring System</small>
    </div>
    <span class="badge bg-primary px-3 py-2">
        <i class="bi bi-calendar-event"></i>
        <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %>
    </span>
</div>

<!-- KPI CARDS -->
<div class="row g-4 mb-4">

<div class="col-md-3">
<div class="card shadow-sm border-0 kpi-ui total">
<div class="card-body">
<i class="bi bi-truck-front kpi-icon"></i>
<h6>Total Vehicles</h6>
<h3><%=totalVehicles%></h3>
</div>
</div>
</div>

<div class="col-md-3">
<div class="card shadow-sm border-0 kpi-ui success">
<div class="card-body">
<i class="bi bi-map kpi-icon"></i>
<h6>Total Trips</h6>
<h3><%=totalTrips%></h3>
</div>
</div>
</div>

<div class="col-md-3">
<div class="card shadow-sm border-0 kpi-ui danger">
<div class="card-body">
<i class="bi bi-fuel-pump kpi-icon"></i>
<h6>Fuel Cost</h6>
<h3>₹ <%=String.format("%.2f",totalFuelCost)%></h3>
</div>
</div>
</div>


</div>

<div class="row g-4 mb-4">

<!-- ACTIVE SERVICES -->
<div class="col-md-3">
<div class="card border-0 shadow-sm kpi-ui success">
<div class="card-body">
<i class="bi bi-tools kpi-icon"></i>
<h6>Active Services</h6>
<h3><%=activeServices%></h3>
</div>
</div>
</div>

<!-- EXPIRED SERVICES -->
<div class="col-md-3">
<div class="card border-0 shadow-sm kpi-ui danger">
<div class="card-body">
<i class="bi bi-x-circle kpi-icon"></i>
<h6>Expired Services</h6>
<h3><%=expiredServices%></h3>
</div>
</div>
</div>

<!-- ACTIVE DOCUMENTS -->
<div class="col-md-3">
<div class="card border-0 shadow-sm kpi-ui primary">
<div class="card-body">
<i class="bi bi-file-earmark-check kpi-icon"></i>
<h6>Active Documents</h6>
<h3><%=activeDocuments%></h3>
</div>
</div>
</div>

<!-- EXPIRED DOCUMENTS -->
<div class="col-md-3">
<div class="card border-0 shadow-sm kpi-ui warning">
<div class="card-body">
<i class="bi bi-file-earmark-x kpi-icon"></i>
<h6>Expired Documents</h6>
<h3><%=expiredDocuments%></h3>
</div>
</div>
</div>

</div>


<!-- TABLE SUMMARY -->
<div class="card border-0 shadow-sm mb-4">
<div class="card-header bg-white fw-semibold">
<i class="bi bi-list-check"></i> Vehicle Summary
</div>
<div class="card-body p-0">
<table class="table table-hover mb-0">
<thead class="table-light">
<tr>
<th>Vehicle</th>
<th>Trips</th>
<th>Fuel Cost (₹)</th>
</tr>
</thead>
<tbody>
<% for(String v:tripCount.keySet()){ %>
<tr>
<td><b><%=v%></b></td>
<td><%=tripCount.get(v)%></td>
<td>₹ <%=String.format("%.2f",fuelCostMap.get(v))%></td>
</tr>
<% } %>
</tbody>
</table>
</div>
</div>

<!-- CHARTS -->
<div class="row g-4">

<div class="col-md-6">
<div class="card border-0 shadow-sm">
<div class="card-header bg-white fw-semibold">
<i class="bi bi-bar-chart"></i> Trips per Vehicle
</div>
<div class="card-body">
<canvas id="tripChart" height="240"></canvas>
</div>
</div>
</div>

<div class="col-md-6">
<div class="card border-0 shadow-sm">
<div class="card-header bg-white fw-semibold">
<i class="bi bi-cash-coin"></i> Fuel Cost per Vehicle
</div>
<div class="card-body">
<canvas id="costChart" height="240"></canvas>
</div>
</div>
</div>

</div>

</div>


<script>
const labels=[<%=labels%>];

new Chart(document.getElementById("tripChart"),{
type:"bar",
data:{labels:labels,datasets:[{data:[<%=tripData%>],backgroundColor:"#4f46e5"}]},
options:{responsive:true}
});

new Chart(document.getElementById("costChart"),{
type:"bar",
data:{labels:labels,datasets:[{data:[<%=costData%>],backgroundColor:"#dc2626"}]},
options:{responsive:true}
});
</script>

</body>
</html>
