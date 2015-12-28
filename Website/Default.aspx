<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Soundcheck | Karte</title>
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
            height: 900px;
            width: 75%;
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
<body onload="loadMeasurements()">
    <!-- Navigation -->
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="#">Soundcheck</a>
            </div>
            <div>
                <ul class="nav navbar-nav">
                    <li ><a href="#" class="active">Lärmkarte</a></li>
                    <li><a href="Info.html">Info</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div>
        <table class="table" style="width: 50%">
            <tr>
                <td>Zeitraum einstellen von dem Messungen geladen werden</td>
                <td>Von:
                    <input type="date" class="input-sm" id="startDatum" /></td>
                <td>Bis:
                    <input type="date" class="input-sm" id="endDatum" /></td>
                <td>
                    <input type="button" class="btn-success" value="Filter eingeben" onclick="neuerFilter()" /></td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <label for="check1">
                            <input type="checkbox" name="view" value="heatmap" checked="checked" id="check1" onclick="drawOverlay(this.value,check1.checked)" >
                            Heatmap
                        </label>
                        <label for="check2">
                            <input type="checkbox" name="view" value="punkte"  id="check2" onclick="drawOverlay(this.value, check2.checked)">
                            Punkte
                        </label>
                        <label for="check3">
                            <input type="checkbox" name="view" value="anzahl" id="check3" onclick="drawOverlay(this.value, check3.checked)">
                            Anzahl
                        </label>
                    </fieldset>
                </td>
            </tr>
        </table>
    </div>

    <form id="form1" runat="server">
        <div id="map" class="map"></div>

    </form>
</body>
</html>
