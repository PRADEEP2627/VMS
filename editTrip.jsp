<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>

<%
response.setHeader("Cache-Control","no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires",0);

if(session.getAttribute("user")==null){
    response.sendRedirect("login.jsp");
    return;
}

String tripFile = "D:/car_data/trips.csv";
int targetIndex = Integer.parseInt(request.getParameter("index"));
String selectedVehicle = request.getParameter("vehicleNo");

String[] trip = null;

/* ===== READ TRIP BY REAL CSV INDEX ===== */
BufferedReader br = new BufferedReader(new FileReader(tripFile));
String line;
int rowIndex = 0;

while((line = br.readLine()) != null){
    if(line.trim().isEmpty()){
        rowIndex++;
        continue;
    }

    if(rowIndex == targetIndex){
        trip = line.split(",", -1);
        break;
    }
    rowIndex++;
}
br.close();

if(trip == null){
    response.sendRedirect("viewTrip.jsp?vehicleNo=" + selectedVehicle);
    return;
}

/* column safety */
while(trip.length < 11){
    trip = Arrays.copyOf(trip, trip.length + 1);
}

/* ===== UPDATE ===== */
if("POST".equalsIgnoreCase(request.getMethod())){

    String updatedLine =
        trip[0] + "," +                              // vehicleNo (fixed)
        request.getParameter("tripFrom").replace(",", " ") + "," +
        request.getParameter("tripTo").replace(",", " ") + "," +
        request.getParameter("distance") + "," +
        request.getParameter("startKm") + "," +
        request.getParameter("endKm") + "," +
        request.getParameter("fuelDistance") + "," +
        request.getParameter("litres") + "," +
        request.getParameter("price") + "," +
        request.getParameter("kmpl") + "," +
        request.getParameter("totalCost");

    List<String> allLines = new ArrayList<>();
    br = new BufferedReader(new FileReader(tripFile));
    rowIndex = 0;

    while((line = br.readLine()) != null){
        if(rowIndex == targetIndex){
            allLines.add(updatedLine);
        } else {
            allLines.add(line);
        }
        rowIndex++;
    }
    br.close();

    BufferedWriter bw = new BufferedWriter(new FileWriter(tripFile));
    for(String l : allLines){
        bw.write(l);
        bw.newLine();
    }
    bw.close();

    response.sendRedirect("viewTrip.jsp?vehicleNo=" + trip[0]);
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Trip | KMCH VMS</title>

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
.form-box{background:#fff;padding:20px;border-radius:16px;box-shadow:0 10px 30px rgba(0,0,0,.06)}
.result-box{background:#e9f5ff;padding:15px;border-radius:12px}
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
    <a href="addTrip.jsp"><i class="bi bi-geo-alt"></i> Add Trip</a>
    <a href="viewTrip.jsp" class="active" ><i class="bi bi-map"></i> Trip Details</a>
    <a href="addService.jsp"><i class="bi bi-tools"></i> Add Service</a>
    <a href="viewService.jsp"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>
</div>


<div class="main-content">
<h4 class="fw-semibold mb-3">Edit Trip</h4>

<div class="form-box">
<form method="post">

<label>Vehicle</label>
<input class="form-control mb-3" value="<%=trip[0]%>" disabled>

<label>From</label>
<input name="tripFrom" class="form-control mb-3" value="<%=trip[1]%>" required>

<label>To</label>
<input name="tripTo" class="form-control mb-3" value="<%=trip[2]%>" required>

<label>Trip Distance</label>
<input name="distance" class="form-control mb-3" value="<%=trip[3]%>">

<hr>

<div class="row">
<div class="col-md-6 mb-3">
<label>Starting KM</label>
<input name="startKm" id="startKm" class="form-control" value="<%=trip[4]%>" oninput="calculateDistance()">
</div>
<div class="col-md-6 mb-3">
<label>Ending KM</label>
<input name="endKm" id="endKm" class="form-control" value="<%=trip[5]%>" oninput="calculateDistance()">
</div>
</div>

<label>Distance Travelled</label>
<input id="fuelDistance" class="form-control mb-3" value="<%=trip[6]%>" readonly>

<div class="row">
<div class="col-md-6 mb-3">
<label>Fuel Used</label>
<input name="litres" id="litres" class="form-control" value="<%=trip[7]%>" oninput="calculateFuel()">
</div>
<div class="col-md-6 mb-3">
<label>Fuel Price</label>
<input name="price" id="price" class="form-control" value="<%=trip[8]%>" oninput="calculateFuel()">
</div>
</div>

<div class="result-box mb-3">
Mileage: <span id="kmpl" class="result-value"><%=trip[9]%> km/L</span><br>
Total Cost: <span id="costDistance" class="result-value">₹ <%=trip[10]%></span>
</div>

<input type="hidden" name="fuelDistance" id="fuelDistanceHidden" value="<%=trip[6]%>">
<input type="hidden" name="kmpl" id="kmplHidden" value="<%=trip[9]%>">
<input type="hidden" name="totalCost" id="costHidden" value="<%=trip[10]%>">

<button class="btn btn-primary">
<i class="bi bi-save"></i> Update Trip
</button>
<a href="viewTrip.jsp?vehicleNo=<%=trip[0]%>" class="btn btn-secondary ms-2">Cancel</a>

</form>
</div>
</div>

</body>
</html>
