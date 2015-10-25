<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
        #map { height: 500px; width: 75% }
    </style>
    <script src="http://openlayers.org/api/OpenLayers.js"></script>
    <script>
        //Funktion ladet Basemap mit Leaflet
        //Gibt ein Objekt des typs Map zurück
        function loadBasemap() {
            //Man benötigt das div mit der ID map, damit Map dort angezeigt wird
            //Position für Mittelpunkt der Karte -> Format ist EPSG 3857
            var latitude = 5964561.74645;
            var longitude = 1539315.13234;
            var zoom = 9;

            var southWest = L.latLng('46.28243', '8.75061');
            var northEast = L.latLng('49.06306925171648', '17.523193359374996');

            var bounds = L.latLngBounds(southWest, northEast);

            map = L.map('map', {
                zoomControl: false,
                minZoom: 8,
                maxZoom: 18,
                maxBounds: bounds
            }).setView([longitude, latitude], zoom);

            //In das richtige Fromat EPSG 3857 umrechnen
            var point = new L.Point(longitude, latitude); // Lon/Lat
            var earthRadius = 6378137;
            var latlng = L.Projection.SphericalMercator.unproject(point.divideBy(earthRadius));

            map.panTo(new L.LatLng(latlng.lat, latlng.lng));

            //source
            L.tileLayer('http://maps.wien.gv.at/basemap/geolandbasemap/normal/google3857/{z}/{y}/{x}.png', {
                attribution: 'Karte: <a href="http://basemap.at" target="_blank">basemap.at</a>, <a href="http://creativecommons.org/licenses/by/3.0/at/deed.de" target="_blank">CC-BY 3.0</a> | <a id="legalinformation">Legal Information</a>',
                tms: false,
                detectRetina: true
            }).addTo(map);
            return map;
        }

        /*
        Methode holt Messorte.
        Dafür wird folgendermaßen vorgegangen:
            -> Lade Karte
            -> Hole Messungen mit AJAX call als Objekt
            -> Speichere Messpunkte als Pin in die Karte
        */
        function loadMeasurements() {
            map = loadBasemap();

            //Hole Messungen mit AJAX von der Default.aspx.cs
            $.ajax({
                type: "POST",
                url: "Default.aspx/GetMessungen",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    try {
                        handleResponse(msg.d);
                    } catch (ex) {
                        alert(ex);
                    }
                    //console.log(msg);
                }
            }
            );
            //Funktion die mit dem Response umgeht -> Response = Objekt mit Orten
            function handleResponse(resp) {
                for (i = 0; i < resp.length; i++) {
                    createPin(resp[i].Longitude, resp[i].Latitude);
                }
                L.control.mousePosition().addTo(map);
            }
            //Funktion erstellt den Pin an long und lat
            function createPin(long, lat) {
                L.marker([long, lat]).addTo(map);
            }
        }

       
    </script>
    <script src="libraries/bootstrap/javascript/bootstrap.min.js"></script>
    <script src="libraries/MousePosition/javascript/L.Control.MousePosition.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="libraries/MousePosition/css/L.Control.MousePosition.css">
    <!-- Optional theme -->
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap.min.css">
</head>
<body onload="loadMeasurements()">
    <form id="form1" runat="server">
        <div id="map" class="map"></div>
        
    </form>
</body>
</html>
