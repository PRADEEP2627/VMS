<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
}

/* ========= SAVE TRIP (NO HEADER, NO S.NO) ========= */
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String basePath = "D:/car_data/";
    File tripFile = new File(basePath + "trips.csv");
    new File(basePath).mkdirs();

    BufferedWriter bw = new BufferedWriter(new FileWriter(tripFile, true));

    bw.write(
        request.getParameter("vehicleNo").replace(",", " ") + "," +
        request.getParameter("tripFrom").replace(",", " ") + "," +
        request.getParameter("tripTo").replace(",", " ") + "," +
        request.getParameter("distance") + "," +
        request.getParameter("startKm") + "," +
        request.getParameter("endKm") + "," +
        request.getParameter("fuelDistance") + "," +
        request.getParameter("litres") + "," +
        request.getParameter("price") + "," +
        request.getParameter("kmpl") + "," +
        request.getParameter("totalCost")
    );
    bw.newLine();
    bw.close();

    response.sendRedirect("viewTrip.jsp?vehicleNo=" + request.getParameter("vehicleNo"));
    return;
}
%>



<!DOCTYPE html>
<html>
<head>
<title>Add Trip | KMCH VMS</title>

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
.form-box{
    background:#fff;padding:20px;border-radius:16px;
    box-shadow:0 10px 30px rgba(0,0,0,.06)
}
.result-box{
    background:#e9f5ff;padding:15px;border-radius:12px
}
.result-value{font-weight:600;color:#2563eb}
</style>

<script>
function calculateDistance(){
    let s=parseFloat(startKm.value);
    let e=parseFloat(endKm.value);
    if(!isNaN(s)&&!isNaN(e)&&e>s){
        let d=e-s;
        fuelDistance.value=d.toFixed(2);
        fuelDistanceHidden.value=d.toFixed(2);
        calculateFuel();
    }
}
function calculateFuel(){
    let d=fuelDistance.value;
    let l=litres.value;
    let p=price.value;
    if(d>0&&l>0&&p>0){
        kmpl.innerText=(d/l).toFixed(2)+" km/L";
        costDistance.innerText="₹ "+(l*p).toFixed(2);
        kmplHidden.value=(d/l).toFixed(2);
        costHidden.value=(l*p).toFixed(2);
    }
}
</script>
</head>

<body>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <h4>KMCH VMS</h4>

    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"class="active" ><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>


<!-- MAIN -->
<div class="main-content">
<h4 class="mb-3 fw-semibold">Add Trip</h4>

<div class="form-box">
<form method="post">

<label class="form-label">Select Vehicle</label>
<select name="vehicleNo" class="form-select mb-3" required>
<option value="">-- Select Vehicle --</option>
<%
BufferedReader br = new BufferedReader(new FileReader("D:/car_data/vehicles.csv"));
String line; 

while ((line = br.readLine()) != null) {
    if (line.trim().isEmpty()) continue; // skip empty lines
    String[] v = line.split(",", -1); // -1 to keep empty fields
    if (v.length < 1) continue; // safety check

%>
<option value="<%=v[0]%>"><%=v[0]%></option>
<%
}
br.close();
%>


</select>

<div class="row">
<div class="col-md-6 mb-3">
<label>From</label>
<input name="tripFrom" class="form-control" required>
</div>
<div class="col-md-6 mb-3">
<label>To</label>
<input name="tripTo" class="form-control" required>
</div>
</div>

<label>Trip Distance</label>
<input name="distance" class="form-control mb-3">

<hr>

<div class="row">
<div class="col-md-6 mb-3">
<label>Starting KM</label>
<input name="startKm" id="startKm" class="form-control" oninput="calculateDistance()">
</div>
<div class="col-md-6 mb-3">
<label>Ending KM</label>
<input name="endKm" id="endKm" class="form-control" oninput="calculateDistance()">
</div>
</div>

<label>Distance Travelled</label>
<input id="fuelDistance" class="form-control mb-3" readonly>

<div class="row">
<div class="col-md-6 mb-3">
<label>Fuel Used</label>
<input name="litres" id="litres" class="form-control" oninput="calculateFuel()">
</div>
<div class="col-md-6 mb-3">
<label>Fuel Price</label>
<input name="price" id="price" class="form-control" oninput="calculateFuel()">
</div>
</div>

<div class="result-box mb-3">
Mileage: <span id="kmpl" class="result-value">-</span><br>
Total Cost: <span id="costDistance" class="result-value">-</span>
</div>

<input type="hidden" name="fuelDistance" id="fuelDistanceHidden">
<input type="hidden" name="kmpl" id="kmplHidden">
<input type="hidden" name="totalCost" id="costHidden">

<button class="btn btn-primary px-3">
<i class="bi bi-save"></i> Save Trip
</button>
<a href="viewTrip.jsp" class="btn btn-secondary ms-2">Cancel</a>

</form>
</div>
</div>

</body>
</html>
