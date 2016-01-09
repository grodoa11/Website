<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Mobile.aspx.cs" Inherits="Mobile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script src="https://code.jquery.com/jquery-1.11.2.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css" />
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="http://openlayers.org/en/v3.9.0/css/ol.css" type="text/css" />
    <script src="http://openlayers.org/en/v3.9.0/build/ol.js"></script>

    <!--Leaflet-->
    <link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet-0.7.5/leaflet.css" />
    <script src="http://cdn.leafletjs.com/leaflet-0.7.5/leaflet.js"></script>

    <style>
        #map {
            height: 1080px;
            width: 100%;
        }
    </style>
    <script src="http://openlayers.org/api/OpenLayers.js"></script>
    <script src="JScript.js"></script>


    <script src="libraries/bootstrap/javascript/bootstrap.min.js"></script>
    <script src="libraries/MousePosition/javascript/L.Control.MousePosition.js"></script>
    <script src="libraries/HeatLayer.js"></script>
    <script src="libraries/leaflet-heat.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="libraries/MousePosition/css/L.Control.MousePosition.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap.min.css">

</head>
<body onload="loadMeasurementsMobile()">
    <form id="form1" runat="server">
    <div id="map" class="map">
    
    </div>
        <button onclick="showCurrentPlace">Show</button>
        <asp:HiddenField ID="hiddenFieldLon" runat="server" />
        <asp:HiddenField runat="server" ID="hiddenFieldLat"/>
    </form>
</body>
</html>
