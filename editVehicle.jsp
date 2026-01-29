<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, java.util.*" %>
<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

if (session.getAttribute("user") == null) {
    response.sendRedirect("login.jsp");
    return;
}

File file = new File("D:/car_data/vehicles.csv");
int rowToEdit = Integer.parseInt(request.getParameter("row")); // 0-based index

List<String[]> vehicles = new ArrayList<>();
String[] vehicleData = null;

/* ===== READ CSV ===== */
if(file.exists()){
    BufferedReader br = new BufferedReader(new FileReader(file));
    String line;
    int currentRow = 0;

    while ((line = br.readLine()) != null) {
        if(line.trim().isEmpty()) continue;

        String[] data = line.split(",");
        vehicles.add(data);

        if(currentRow == rowToEdit){
            vehicleData = data;
        }

        currentRow++;
    }
    br.close();
}

/* ===== UPDATE ===== */
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String[] updatedRow = new String[] {
        request.getParameter("regNo"),
        request.getParameter("model"),
        request.getParameter("fuelType"),
        request.getParameter("color"),
        request.getParameter("regDate"),
        request.getParameter("ownerName"),
        request.getParameter("ownerAddress").replace(",", " "),
        request.getParameter("rto"),
        request.getParameter("rcStatus"),
        request.getParameter("dlStatus"),
        request.getParameter("insurance"),
        request.getParameter("puc")
    };

    // Replace the row in list
    vehicles.set(rowToEdit, updatedRow);

    // Rewrite CSV (no header)
    BufferedWriter bw = new BufferedWriter(new FileWriter(file));
    for(String[] v : vehicles){
        bw.write(String.join(",", v));
        bw.newLine();
    }
    bw.close();

    response.sendRedirect("viewVehicle.jsp");
}
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Vehicle | KMCH VMS</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<style>
body { margin:0; background:#f4f6f9; font-family: system-ui, -apple-system, "Segoe UI", Roboto;}
.sidebar{position:fixed; top:0; left:0; width:250px; height:100vh; background:#111827; padding:20px 15px;}
.sidebar h4{color:#fff; text-align:center; font-weight:600; margin-bottom:25px;}
.sidebar a{display:flex; align-items:center; gap:12px; padding:12px 15px; margin-bottom:8px; color:#cbd5e1; text-decoration:none; border-radius:10px; font-weight:500; transition:all 0.25s ease;}
.sidebar a:hover,
.sidebar a.active {
    /* Use Total Vehicles card gradient */
    background: linear-gradient(135deg, #38bdf8, #2563eb);
    color: #fff; /* white text for contrast */
    font-weight:600;
}
.sidebar .logout-link:hover{background:#dc2626;}
.sidebar i{font-size:18px;}
.main-content{margin-left:250px; padding:30px;}
.card{border-radius:16px; border:none; box-shadow:0 10px 30px rgba(0,0,0,0.06);}
.section-title{font-weight:600; color:#374151; margin-top:25px;}
</style>
</head>
<body>

<!-- Sidebar -->
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

<div class="main-content">
<h4 class="mb-3 fw-semibold">Edit Vehicle</h4>
<div class="card p-4">
<form method="post">

<%-- Vehicle Details --%>
<div class="section-title">Vehicle Details</div>
<div class="row mt-3">
    <div class="col-md-4 mb-3">
        <label>Registration No</label>
        <input type="text" name="regNo" class="form-control" value="<%= vehicleData != null ? vehicleData[0] : "" %>" required>
    </div>
    <div class="col-md-4 mb-3">
        <label>Model / Make</label>
        <input type="text" name="model" class="form-control" value="<%= vehicleData != null ? vehicleData[1] : "" %>" required>
    </div>
    <div class="col-md-4 mb-3">
        <label>Fuel Type</label>
        <select name="fuelType" class="form-select" required>
            <option value="">Select</option>
            <option value="Petrol" <%= vehicleData != null && "Petrol".equals(vehicleData[2]) ? "selected" : "" %>>Petrol</option>
            <option value="Diesel" <%= vehicleData != null && "Diesel".equals(vehicleData[2]) ? "selected" : "" %>>Diesel</option>
            <option value="Electric" <%= vehicleData != null && "Electric".equals(vehicleData[2]) ? "selected" : "" %>>Electric</option>
            <option value="CNG" <%= vehicleData != null && "CNG".equals(vehicleData[2]) ? "selected" : "" %>>CNG</option>
        </select>
    </div>
    <div class="col-md-4 mb-3">
        <label>Color</label>
        <input type="text" name="color" class="form-control" value="<%= vehicleData != null ? vehicleData[3] : "" %>">
    </div>
    <div class="col-md-4 mb-3">
        <label>Registration Date</label>
        <input type="date" name="regDate" class="form-control" value="<%= vehicleData != null ? vehicleData[4] : "" %>" required>
    </div>
    <div class="col-md-4 mb-3">
        <label>RTO</label>
        <input type="text" name="rto" class="form-control" value="<%= vehicleData != null ? vehicleData[7] : "" %>">
    </div>
</div>

<div class="section-title">Owner Details</div>
<div class="row mt-3">
    <div class="col-md-6 mb-3">
        <label>Owner Name</label>
        <input type="text" name="ownerName" class="form-control" value="<%= vehicleData != null ? vehicleData[5] : "" %>" required>
    </div>
    <div class="col-md-6 mb-3">
        <label>Owner Address</label>
        <input type="text" name="ownerAddress" class="form-control" value="<%= vehicleData != null ? vehicleData[6] : "" %>">
    </div>
</div>

<div class="section-title">Documents & Validity</div>
<div class="row mt-3">
    <div class="col-md-3 mb-3">
        <label>RC Status</label>
        <select name="rcStatus" class="form-select">
            <option value="Valid" <%= vehicleData != null && "Valid".equals(vehicleData[8]) ? "selected" : "" %>>Valid</option>
            <option value="Expired" <%= vehicleData != null && "Expired".equals(vehicleData[8]) ? "selected" : "" %>>Expired</option>
        </select>
    </div>
    <div class="col-md-3 mb-3">
        <label>Driving License</label>
        <select name="dlStatus" class="form-select">
            <option value="Valid" <%= vehicleData != null && "Valid".equals(vehicleData[9]) ? "selected" : "" %>>Valid</option>
            <option value="Expired" <%= vehicleData != null && "Expired".equals(vehicleData[9]) ? "selected" : "" %>>Expired</option>
        </select>
    </div>
    <div class="col-md-3 mb-3">
        <label>Insurance</label>
        <select name="insurance" class="form-select">
            <option value="Valid" <%= vehicleData != null && "Valid".equals(vehicleData[10]) ? "selected" : "" %>>Valid</option>
            <option value="Expired" <%= vehicleData != null && "Expired".equals(vehicleData[10]) ? "selected" : "" %>>Expired</option>
        </select>
    </div>
    <div class="col-md-3 mb-3">
        <label>PUC</label>
        <select name="puc" class="form-select">
            <option value="Valid" <%= vehicleData != null && "Valid".equals(vehicleData[11]) ? "selected" : "" %>>Valid</option>
            <option value="Expired" <%= vehicleData != null && "Expired".equals(vehicleData[11]) ? "selected" : "" %>>Expired</option>
        </select>
    </div>
</div>

<hr>
<button class="btn btn-primary"><i class="bi bi-save"></i> Update Vehicle</button>
<a href="viewVehicle.jsp" class="btn btn-secondary">Cancel</a>

</form>
</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
