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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Vehicle | KMCH VMS</title>

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
/* Cards */
.card{
    border-radius:16px;
    border:none;
    box-shadow:0 10px 30px rgba(0,0,0,0.06);
}

/* Section title */
.section-title{
    font-weight:600;
    color:#374151;
    margin-top:25px;
}
</style>
</head>

<body>
<%
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String regNo      = request.getParameter("regNo");
    String model      = request.getParameter("model");
    String fuelType   = request.getParameter("fuelType");
    String color      = request.getParameter("color");
    String regDate    = request.getParameter("regDate");
    String ownerName  = request.getParameter("ownerName");
    String ownerAddr  = request.getParameter("ownerAddress");
    String rto        = request.getParameter("rto");
    String rcStatus   = request.getParameter("rcStatus");
    String dlStatus   = request.getParameter("dlStatus");
    String insurance  = request.getParameter("insurance");
    String puc        = request.getParameter("puc");

    // File path
    File file = new File("D:/car_data/vehicles.csv");
    file.getParentFile().mkdirs();

    // Write data directly, no header, no S.No
    BufferedWriter bw = new BufferedWriter(new FileWriter(file, true));

    bw.write(
        regNo + "," +
        model + "," +
        fuelType + "," +
        color + "," +
        regDate + "," +
        ownerName + "," +
        ownerAddr.replace(",", " ") + "," +
        rto + "," +
        rcStatus + "," +
        dlStatus + "," +
        insurance + "," +
        puc
    );
    bw.newLine();
    bw.close();

    response.sendRedirect("viewVehicle.jsp");
}
%>




<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <h4>KMCH VMS</h4>

    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp" class="active"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<!-- ===== MAIN CONTENT ===== -->
<div class="main-content">

<h4 class="mb-3 fw-semibold">Add Vehicle</h4>

<div class="card p-4">

<form method="post">

<!-- VEHICLE DETAILS -->
<div class="section-title">Vehicle Details</div>
<div class="row mt-3">

    <div class="col-md-4 mb-3">
        <label class="form-label">Registration Number</label>
        <input type="text" name="regNo" class="form-control" required>
    </div>

    <div class="col-md-4 mb-3">
        <label class="form-label">Model / Make</label>
        <input type="text" name="model" class="form-control" required>
    </div>

    <div class="col-md-4 mb-3">
        <label class="form-label">Fuel Type</label>
        <select name="fuelType" class="form-select" required>
            <option value="">Select</option>
            <option>Petrol</option>
            <option>Diesel</option>
            <option>Electric</option>
            <option>CNG</option>
        </select>
    </div>

    <div class="col-md-4 mb-3">
        <label class="form-label">Color</label>
        <input type="text" name="color" class="form-control">
    </div>

    <div class="col-md-4 mb-3">
        <label class="form-label">Registration Date</label>
        <input type="date" name="regDate" class="form-control" required>
    </div>

    <div class="col-md-4 mb-3">
        <label class="form-label">RTO</label>
        <input type="text" name="rto" class="form-control">
    </div>

</div>

<!-- OWNER DETAILS -->
<div class="section-title">Owner Details</div>
<div class="row mt-3">

    <div class="col-md-6 mb-3">
        <label class="form-label">Owner Name</label>
        <input type="text" name="ownerName" class="form-control" required>
    </div>

    <div class="col-md-6 mb-3">
        <label class="form-label">Owner Address</label>
        <input type="text" name="ownerAddress" class="form-control">
    </div>

</div>

<!-- DOCUMENT STATUS -->
<div class="section-title">Documents & Validity</div>
<div class="row mt-3">

    <div class="col-md-3 mb-3">
        <label class="form-label">RC Status</label>
        <select name="rcStatus" class="form-select">
            <option>Valid</option>
            <option>Expired</option>
        </select>
    </div>

    <div class="col-md-3 mb-3">
        <label class="form-label">Driving License</label>
        <select name="dlStatus" class="form-select">
            <option>Valid</option>
            <option>Expired</option>
        </select>
    </div>

    <div class="col-md-3 mb-3">
        <label class="form-label">Insurance</label>
        <select name="insurance" class="form-select">
            <option>Valid</option>
            <option>Expired</option>
        </select>
    </div>

    <div class="col-md-3 mb-3">
        <label class="form-label">PUC Certificate</label>
        <select name="puc" class="form-select">
            <option>Valid</option>
            <option>Expired</option>
        </select>
    </div>

</div>

<hr>

<button class="btn btn-primary px-3">
    <i class="bi bi-save"></i> Save Vehicle
</button>
<a href="viewVehicle.jsp" class="btn btn-secondary">
    Cancel
</a>

</form>

</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
