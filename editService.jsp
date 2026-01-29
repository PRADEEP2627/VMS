<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*,java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<title>Edit Service | KMCH VMS</title>

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
.sidebar .logout-link:hover{background:#dc2626;}

/* ===== Content ===== */
.main-content{
    margin-left:250px;
    padding:30px;
}
.card{border-radius:16px;}
.module-card{
    background:#fff;border-radius:12px;
    border:1px solid #e5e7eb;margin-bottom:16px;
}
.module-header{
    padding:10px 15px;
    background:linear-gradient(135deg,#38bdf8,#2563eb);
    color:#fff;font-weight:600;cursor:pointer;
    border-radius:12px 12px 0 0;
    display:flex;justify-content:space-between;
}
.module-body{display:none;padding:15px;}
.module-body.active{display:block;}
</style>
</head>

<body>

<%
String serviceFile = "D:/car_data/services.txt";
String vehicleNo = request.getParameter("vehicle");
String editType  = request.getParameter("type");

/* ===== UPDATE SERVICE ===== */
if("POST".equalsIgnoreCase(request.getMethod())){
    String vNo = request.getParameter("vehicleNo");

    List<String> updated = new ArrayList<>();
    BufferedReader br = new BufferedReader(new FileReader(serviceFile));
    String line;

    while((line = br.readLine()) != null){
        String[] s = line.split(",");
        if(s.length < 6) continue;

        if(s[0].equals(vNo)){
            String module = s[1];
            String sd = request.getParameter(module+"_serviceDate");
            String nd = request.getParameter(module+"_nextDate");
            String km = request.getParameter(module+"_km");
            String pr = request.getParameter(module+"_price");

            if(km != null && !km.isEmpty()){
                updated.add(vNo+","+module+","+sd+","+nd+","+km+","+pr);
            }
        }else{
            updated.add(line);
        }
    }
    br.close();

    BufferedWriter bw = new BufferedWriter(new FileWriter(serviceFile));
    for(String s : updated){
        bw.write(s); bw.newLine();
    }
    bw.close();

    response.sendRedirect("viewService.jsp?vehicleNo="+vNo);
    return;
}

/* ===== LOAD EXISTING SERVICE DATA ===== */
Map<String,String[]> data = new HashMap<>();

if(vehicleNo != null && new File(serviceFile).exists()){
BufferedReader br = new BufferedReader(new FileReader(serviceFile));
String line;
while((line=br.readLine())!=null){
    String[] s=line.split(",");
    if(s.length<6) continue;
    if(s[0].equals(vehicleNo)){
        data.put(s[1], s);
    }
}
br.close();
}
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
    <a href="viewService.jsp"class="active"><i class="bi bi-clipboard-check"></i> Service Details</a>
    <a href="report.jsp"><i class="bi bi-bar-chart"></i> Reports</a>
    <a href="logout.jsp" class="logout-link">Logout</a>

</div>

<!-- ===== MAIN ===== -->
<div class="main-content">
<h4 class="fw-semibold mb-4">Edit Service – <%=vehicleNo%></h4>

<div class="card shadow-sm p-4 col-lg-9">
<form method="post">

<input type="hidden" name="vehicleNo" value="<%=vehicleNo%>">

<%
String[][] modules={
 {"Tires","Tyres"},
 {"Brakes","Brakes"},
 {"Alignment","Alignment"},
 {"Batteries","Batteries"},
 {"OilChange","Oil Change"}
};

for(String[] m:modules){
String[] s = data.get(m[0]);
String sd = s!=null?s[2]:"";
String nd = s!=null?s[3]:"";
String km = s!=null?s[4]:"";
String pr = s!=null?s[5]:"";
%>

<div class="module-card">
<div class="module-header" onclick="toggle(this)">
<span><%=m[1]%></span>
<i class="bi bi-chevron-down"></i>
</div>

<div class="module-body active">

<div class="row mb-3">
<div class="col-md-6">
<label class="form-label">Service Date</label>
<input type="date" name="<%=m[0]%>_serviceDate" value="<%=sd%>" class="form-control">
</div>
<div class="col-md-6">
<label class="form-label">Next Service Date</label>
<input type="date" name="<%=m[0]%>_nextDate" value="<%=nd%>" class="form-control">
</div>
</div>

<div class="row">
<div class="col-md-6 mb-3">
<label class="form-label">KM</label>
<input type="number" name="<%=m[0]%>_km" value="<%=km%>" class="form-control">
</div>
<div class="col-md-6 mb-3">
<label class="form-label">Price (₹)</label>
<input type="number" name="<%=m[0]%>_price" value="<%=pr%>" class="form-control">
</div>
</div>

</div>
</div>

<% } %>

<hr>
<button class="btn btn-success px-4">
<i class="bi bi-save"></i> Update Service
</button>
<a href="viewService.jsp?vehicleNo=<%=vehicleNo%>" class="btn btn-secondary ms-2">Cancel</a>

</form>
</div>
</div>

<script>
function toggle(el){
 const b = el.nextElementSibling;
 b.classList.toggle("active");
 el.querySelector("i").classList.toggle("bi-chevron-up");
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
