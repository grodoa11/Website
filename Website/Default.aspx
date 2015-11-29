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
        #map {
            height: 900px;
            width: 75%;
        }
    </style>
    <script src="http://openlayers.org/api/OpenLayers.js"></script>

    <script>
        //Member für Heatmap
        var feld = [];
        var auswahl = "lautstaerke";

        //Eigener Marker mit Informationen wie Wert
        SoundCheckMarker = L.Marker.extend({
            options: {
                Wert: 'Wert',
                Zeitpunkt: 'Zeitpunkt'
            }
        });

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
                //minZoom: 8,
                //maxZoom: 18,
                //maxBounds: bounds
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


            //Open Street Map für Testzwecke
            //var tiles = L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
            //    attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
            //}).addTo(map);



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

        }


        //Funktion die mit dem Response umgeht -> Response = Objekt mit Orten
        //befüllt die Daten für Heatmap
        function handleResponse(resp) {
            
            
            
            for (i = 0; i < resp.length; i++) {

                createPin(resp[i]);

                if (auswahl == "anzahl")
                {
                    fillHeatMapDataAnzahl(resp[i]);
                }
                else if (auswahl == "lautstaerke")
                {
                    //fillHeatMapDataLaut(resp[i]);
                }
                var intense = 0;
                if (resp[i].Wert >= 80)
                {
                    feld[i] = [resp[i].Standort.Longitude, resp[i].Standort.Latitude, 0.8];
                }
                else if (resp[i].Wert >= 60)
                {
                    feld[i] = [resp[i].Standort.Longitude, resp[i].Standort.Latitude, 0.6];
                } else if (resp[i].Wert >= 40) {
                    feld[i] = [resp[i].Standort.Longitude, resp[i].Standort.Latitude, 0.4];
                }
                else if (resp[i].Wert < 40) {
                    feld[i] = [resp[i].Standort.Longitude, resp[i].Standort.Latitude, 0.1];
                }
                
                

            }
            //Fügt einen Pointer hinzu, der die Koordinaten unter dem Mauszeiger liefert.
            L.control.mousePosition().addTo(map);
            //Fügt die HeatMap hinzu
            loadHeatMap(feld);


            console.log("test");

        }

        function fillHeatMapDataAnzahl(data) {

            feld[i] = [data.Standort.Longitude, data.Standort.Latitude, 0.8];
        }

        function fillHeatMapDataAnzahl(data)
        {
            var intense = 0;
            if (data.Wert >= 80) {
                intense = 0.8;
            }
            else if (resp[i].Wert >= 60) {
                intense = 0.6;
            } else if (resp[i].Wert >= 40) {
                intense = 0.4;
            }
            else if (resp[i].Wert < 40) {
                intense = 0.1;
            }
            feld[i] = [data.Standort.Longitude, data.Standort.Latitude, intense];


        }
        //Funktion erstellt und fügt HeatMap in die Map ein
        function loadHeatMap(feld) {
            var heat = L.heatLayer(
                            feld
                        , { radius: 25, maxZoom:14, blur:15}).addTo(map);
        }

        //Funktion erstellt den Pin an long und lat
        function createPin(obj) {
            var punkt = [obj.Standort.Longitude, obj.Standort.Latitude];
            //Erstelle eigenen Marker mit dem am Beginn deklarierten Objekt
            var marker = new SoundCheckMarker(punkt, {
                title: obj.Wert + " db",
                Wert: obj.Wert,
                Zeitpunkt: obj.ZeitpunktDerMessung
            });

            //Binde ein Popup an den Marker der die wichtigsten Informationen enthält
            marker.bindPopup("<b>Messung</b><br><b>Messzeitpunkt</b>: " + obj.ZeitpunktForJavascript + " <br>" +
                "<b>Lautstärke</b>: " + obj.Wert +" db").openPopup();
            marker.addTo(map);
        }



        function neuerFilter() {
            var startdatum = document.getElementById("startDatum").value;
            var enddatum = document.getElementById("endDatum").value;
            var obj = new Object();
            obj.startdatum = startdatum;
            obj.enddatum = enddatum;
            $.ajax({
                type: "POST",
                url: "Default.aspx/GetMessungenGefiltert",
                data: JSON.stringify(obj),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    try {
                        alert(msg);
                    } catch (ex) {
                        alert(ex);
                    }
                    //console.log(msg);
                }
            }
            );
        }


    </script>
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
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="#">SoundCheck</a>
            </div>
            <div>
                <ul class="nav navbar-nav">
                    <li class="active"><a href="#">Home</a></li>
                </ul>
                <ul class="nav navbar-nav navbar-right">
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
        </table>
    </div>

    <form id="form1" runat="server">
        <div id="map" class="map"></div>

    </form>
</body>
</html>
