<%@ page language="java" %>
<%@ page import="java.io.*" %>

<%
try {
    String type = request.getParameter("type");
    String vehicle = request.getParameter("vehicle");
    String format = request.getParameter("format");

    if(format == null) format = "txt";

    response.reset();
    response.setContentType("text/plain; charset=UTF-8");
    response.setHeader(
        "Content-Disposition",
        "attachment; filename=" + type + "_" + (vehicle!=null?vehicle:"all") + ".txt"
    );

    int i = 1;
    String line;
    BufferedReader br = null;

    if("vehicle".equals(type)){
        out.println("#,Vehicle No,Name,Owner");
        br = new BufferedReader(new FileReader("D:/car_data/vehicles.txt"));
        while((line = br.readLine()) != null){
            String[] v = line.split(",");
            out.println(i++ + "," + v[0] + "," + v[1] + "," + v[2]);
        }
    }

    else if("trip".equals(type)){
        out.println("#,Vehicle,From,To,KM");
        br = new BufferedReader(new FileReader("D:/car_data/trips.txt"));
        while((line = br.readLine()) != null){
            String[] t = line.split(",");
            if(vehicle != null && !vehicle.equals("") && !t[0].equals(vehicle))
                continue;
            out.println(i++ + "," + t[0] + "," + t[1] + "," + t[2] + "," + t[3]);
        }
    }

    else if("service".equals(type)){
        out.println("#,Vehicle,Date,Type,Cost");
        br = new BufferedReader(new FileReader("D:/car_data/services.txt"));
        while((line = br.readLine()) != null){
            String[] s = line.split(",");
            if(vehicle != null && !vehicle.equals("") && !s[0].equals(vehicle))
                continue;
            out.println(i++ + "," + s[0] + "," + s[1] + "," + s[2] + "," + s[5]);
        }
    }

    else if("fuel".equals(type)){
        out.println("#,Vehicle,Litres,Price,Total");
        br = new BufferedReader(new FileReader("D:/car_data/trips.txt"));
        while((line = br.readLine()) != null){
            String[] f = line.split(",");
            if(vehicle != null && !vehicle.equals("") && !f[0].equals(vehicle))
                continue;
            out.println(i++ + "," + f[0] + "," + f[7] + "," + f[8] + "," + f[10]);
        }
    }

    if(br != null) br.close();

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>
