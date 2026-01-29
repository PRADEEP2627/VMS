<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Add Service | KMCH VMS</title>

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
.sidebar .logout-link:hover{background:#dc2626;}

.sidebar i{
    font-size:18px;
}

/* ===== Content ===== */
.main-content{
    margin-left:250px;
    padding:30px;
}

.module-card{
    background:#fff;
    border-radius:12px;
    border:1px solid #e5e7eb;
    margin-bottom:16px;
}
.module-header{
    padding:10px 15px;
    background:linear-gradient(135deg,#38bdf8,#2563eb);
    color:#fff;
    font-weight:600;
    cursor:pointer;
    border-radius:12px 12px 0 0;
    display:flex;
    justify-content:space-between;
}
.module-body{display:none;padding:15px;}
.module-body.active{display:block;}
</style>
</head>

<body>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {

    String vehicleNo = request.getParameter("vehicleNo");

    /* ================= SERVICE CSV ================= */
    String servicePath = "D:/car_data/services.csv";
    File serviceFile = new File(servicePath);
    serviceFile.getParentFile().mkdirs();

    BufferedWriter serviceBW = new BufferedWriter(
        new FileWriter(serviceFile, true)
    );

    String[] serviceModules = {"Tires","Brakes","Alignment","Batteries","OilChange"};

    for (String m : serviceModules) {

        String sDate = request.getParameter(m + "_serviceDate");
        String nDate = request.getParameter(m + "_nextDate");
        String km    = request.getParameter(m + "_km");
        String price = request.getParameter(m + "_price");

        if (
            (sDate != null && !sDate.isEmpty()) ||
            (nDate != null && !nDate.isEmpty()) ||
            (km != null && !km.isEmpty()) ||
            (price != null && !price.isEmpty())
        ) {
            serviceBW.write(
                vehicleNo + "," + m + "," +
                (sDate != null ? sDate : "") + "," +
                (nDate != null ? nDate : "") + "," +
                (km != null ? km : "") + "," +
                (price != null ? price : "")
            );
            serviceBW.newLine();
        }
    }
    serviceBW.close();


    /* ================= DOCUMENT CSV ================= */
    String docPath = "D:/car_data/vehicle_documents.csv";
    File docFile = new File(docPath);
    docFile.getParentFile().mkdirs();

    BufferedWriter docBW = new BufferedWriter(
        new FileWriter(docFile, true)
    );

    String[][] documentModules = {
        {"insurance","Insurance"},
        {"polution","Pollution"},
        {"rcbook","RC Book"},
        {"fitness","Fitness Certificate"}
    };

    for (String[] d : documentModules) {

        String from = request.getParameter(d[0] + "_from");
        String to   = request.getParameter(d[0] + "_to");
        String rem  = request.getParameter(d[0] + "_remark");

        if (
            (from != null && !from.isEmpty()) ||
            (to != null && !to.isEmpty()) ||
            (rem != null && !rem.isEmpty())
        ) {
            docBW.write(
                vehicleNo + "," + d[1] + "," +
                (from != null ? from : "") + "," +
                (to != null ? to : "") + "," +
                (rem != null ? rem.replace(",", " ") : "")
            );
            docBW.newLine();
        }
    }
    docBW.close();

    response.sendRedirect("viewService.jsp?vehicleNo=" + vehicleNo);
    return;
}
%>


<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
    <h4>KMCH VMS</h4>

    <a href="index.jsp"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="addVehicle.jsp"><i class="bi bi-plus-circle"></i> Add Vehicle</a>
    <a href="viewVehicle.jsp"><i class="bi bi-car-front"></i> View Vehicles</a>
    <a href="addTrip.jsp" ><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp"><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"class="active"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>

<!-- MAIN -->
<div class="main-content">
<h4 class="fw-semibold mb-4">Add Service Details</h4>

<div class="card shadow-sm p-4 col-lg-9">
<form method="post">

<!-- VEHICLE -->
<!-- VEHICLE + ACTION BUTTONS -->
<div class="row mb-4 align-items-end">

    <!-- VEHICLE DROPDOWN -->
    <div class="col-md-4">
        <label class="form-label fw-semibold">Select Vehicle</label>
        <select name="vehicleNo" class="form-select" required>
    <option value="">-- Select Vehicle --</option>
    <%
    String vf = "D:/car_data/vehicles.csv";
    File vFile = new File(vf);
    if(vFile.exists()){
        BufferedReader br = new BufferedReader(new FileReader(vFile));
        String l;
        while((l = br.readLine()) != null){
            if(l.trim().isEmpty()) continue;
            String[] v = l.split(",", -1);
            String vNo = v.length > 0 ? v[0] : "";
            String vName = v.length > 1 ? v[1] : "";
    %>
    <option value="<%=vNo%>"><%=vNo%><% if(!vName.isEmpty()){ %> - <%=vName%><% } %></option>
    <%
        }
        br.close();
    }
    %>
</select>

    </div>

    <!-- BUTTONS -->
    <div class="col-md-8 d-flex gap-3">
        <button type="button" class="btn btn-primary px-4"
                onclick="showService()">
            <i class="bi bi-tools"></i> Vehicle Service
        </button>

        <button type="button" class="btn btn-secondary px-4"
                onclick="showDocument()">
            <i class="bi bi-file-earmark-text"></i> Vehicle Document
        </button>
    </div>

</div>



<!-- ===== VEHICLE SERVICE MODULES ===== -->
<div id="serviceSection" style="display:none">

<%
String[][] serviceModules={
 {"Tires","Tyres"},
 {"Brakes","Brakes"},
 {"Alignment","Alignment"},
 {"Batteries","Batteries"},
 {"OilChange","Oil Change"}
};
for(String[] m:serviceModules){
%>

<div class="module-card">
    <div class="module-header" onclick="toggle(this)">
        <span><%=m[1]%></span>
        <i class="bi bi-chevron-down"></i>
    </div>

    <div class="module-body">
        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Service Date</label>
                <input type="date" name="<%=m[0]%>_serviceDate" class="form-control">
            </div>
            <div class="col-md-6">
                <label class="form-label">Next Service Date</label>
                <input type="date" name="<%=m[0]%>_nextDate" class="form-control">
            </div>
        </div>

        <div class="row">
            <div class="col-md-6">
                <label class="form-label">KM</label>
                <input type="number" name="<%=m[0]%>_km" class="form-control">
            </div>
            <div class="col-md-6">
                <label class="form-label">Price</label>
                <input type="number" name="<%=m[0]%>_price" class="form-control">
            </div>
        </div>
    </div>
</div>

<% } %>
</div>
<!-- ===== VEHICLE DOCUMENT MODULES ===== -->
<div id="documentSection" style="display:none">

<%
String[][] documentModules={
 {"insurance","Insurance"},
 {"polution","Pollution"},
 {"rcbook","RC Book"},
 {"fitness","Fitness Certificate"}
};
for(String[] d:documentModules){
%>

<div class="module-card">
    <div class="module-header" onclick="toggle(this)">
        <span><%=d[1]%></span>
        <i class="bi bi-chevron-down"></i>
    </div>

    <div class="module-body">
        <div class="row mb-3">
            <div class="col-md-6">
                <label class="form-label">Valid From</label>
                <input type="date" name="<%=d[0]%>_from" class="form-control">
            </div>
            <div class="col-md-6">
                <label class="form-label">Valid To</label>
                <input type="date" name="<%=d[0]%>_to" class="form-control">
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Remarks</label>
            <input type="text" name="<%=d[0]%>_remark" class="form-control">
        </div>
    </div>
</div>

<% } %>
</div>


<hr>
<button class="btn btn-primary px-3">
<i class="bi bi-save"></i> Save Service
</button>
<a href="viewService.jsp" class="btn btn-secondary ms-2">Cancel</a>

</form>
</div>
</div>

<script>
function showService(){
    document.getElementById("serviceSection").style.display = "block";
    document.getElementById("documentSection").style.display = "none";
}

function showDocument(){
    document.getElementById("documentSection").style.display = "block";
    document.getElementById("serviceSection").style.display = "none";
}

function toggle(el){
    const body = el.nextElementSibling;
    body.classList.toggle("active");
    el.querySelector("i").classList.toggle("bi-chevron-up");
}
</script>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
