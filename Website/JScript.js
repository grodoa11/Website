﻿//Member für Heatmap
var feld = [];
var auswahl = "punkte";
var msgPoint;
var msgTrack;
var pointsPoint = [];
var pointsPointTrack = [];
var points = [];
var punktLayer;
var punktLayerTrack;
var heatmap;
var zaehlertimetracking = 0;
var map;
var checkHeat = false, checkPunkt = false, checkTrack = false, checkAnz = false, checkMobile = false; //evt. für filter

//Eigener Marker mit Informationen wie Wert
SoundCheckMarker = L.Marker.extend({
    options: {
        Wert: 'Wert',
        Zeitpunkt: 'Zeitpunkt'

    }
});




var myIcon = L.icon({
    iconUrl: 'img/marker-icon_green.png',

    iconAnchor: [12, 40],

});


//Eigenes Icon für den aktuellen Standort (icon url zeigt durch window.location.origin immer auf die richtige Position)s
var currentPlaceIcon = L.icon({

    iconUrl: window.location.origin + "/img/standort.png",
    iconSize: [40, 40]

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
        zoomControl: false

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
    var width = $(window).width();
    document.getElementById("map").style.width = width;

    var options = ["Decibels"];

    //Hole Messungen mit AJAX von der Default.aspx.cs
    $.ajax({
        type: "POST",
        url: "Default.aspx/GetMessungen",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            try {
                //Fügt einen Pointer hinzu, der die Koordinaten unter dem Mauszeiger liefert.
                L.control.mousePosition().addTo(map);

                msgPoint = msg.d;

                drawOverlay("punkte", true);
            } catch (ex) {
                alert(ex);

            }
            //console.log(msg);
        }
    }
    );

    $.ajax({
        type: "POST",
        url: "Default.aspx/GetMessungenTimeTracking",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            try {
                //Fügt einen Pointer hinzu, der die Koordinaten unter dem Mauszeiger liefert.
                L.control.mousePosition().addTo(map);

                msgTrack = msg.d;

            } catch (ex) {
                alert(ex);

            }
            //console.log(msg);
        }
    }
    );


}

//Funktion zeichnet das Diagramm für die TimeTrackingMessung
function drawDiagram(obj) {
    console.log(obj);
    var intervall = obj.Intervall;
    var labs = [];
    var werte = [];
    if (obj.Messwerte.length < 10) {
        for (var i = 0; i < obj.Messwerte.length; i++) {
            werte[i] = obj.Messwerte[i].Wert;
            labs[i] = 1 * i;
        }
    } else {
        for (var i = 0; i < obj.Messwerte.length / 2; i++) {
            werte[i] = obj.Messwerte[i + 1].Wert;
            labs[i] = 1 * (i + 1);
        }
    }

    var ctx = document.getElementById("can" + obj.ID).getContext("2d");

    var data = {
        labels: labs,
        datasets: [
            {
                label: "Messungen",
                fillColor: "rgba(220,220,220,0.2)",
                strokeColor: "rgba(220,220,220,1)",
                pointColor: "rgba(220,220,220,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: werte
            }
        ]
    };


    var myLineChart = new Chart(ctx).Line(data);
    zaehlertimetracking++;
}


function loadMeasurementsMobile() {
    map = loadBasemap();
    showCurrentPlace();
    var heightmob = $(window).height();
    document.getElementById("map").style.height = heightmob;
    $(window).trigger('resize');

    //Hole Messungen mit AJAX von der Default.aspx.cs
    $.ajax({
        type: "POST",
        url: "Mobile.aspx/GetMessungen",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            try {


                msgPoint = msg.d;

                drawOverlay("mobile", true);
            } catch (ex) {
                alert(ex);
            }
            //console.log(msg);
        }
    }
    );


}
function showCurrentPlace() {
    var lat = document.getElementById("hiddenFieldLat").value;
    var lon = document.getElementById("hiddenFieldLon").value;
    map.panTo(new L.LatLng(lat, lon));
    var marker = L.marker([lat, lon], { icon: currentPlaceIcon });
    marker.bindPopup("<b>Du bist hier</b>");
    marker.addTo(map);
}


//Funktion die mit dem Response umgeht -> Response = Objekt mit Orten
//befüllt die Daten für Heatmap
function handleResponse(resp) {

    for (i = 0; i < resp.length; i++) {

        if (auswahl == "mobile") {

            createPin(resp[i], i);
            fillHeatMapDataLaut(resp[i], i);

        }
        if (auswahl == "anzahl") {
            fillHeatMapDataAnzahl(resp[i], i);
            //loadHeatMap(feld);
        }
        else if (auswahl == "heatmap") {

            fillHeatMapDataLaut(resp[i], i);



        }
        else if (auswahl == "punkte") {
            createPin(resp[i], i);
        }
        else if (auswahl == "track") {
            createPinTrack(resp[i]);
        }
    }
    if (auswahl == "heatmap" || auswahl == "mobile") {
        loadHeatMap();

    }
    console.log("test");

}

function fillHeatMapDataAnzahl(resp, i) {

    feld[i] = [data.Standort.Longitude, data.Standort.Latitude, 0.8];
}

function fillHeatMapDataLaut(resp, i) {

    var intense = 0;
    if (resp.Wert >= 80) {
        feld[i] = [resp.Standort.Longitude, resp.Standort.Latitude, 0.95];
    }
    else if (resp.Wert >= 60) {
        feld[i] = [resp.Standort.Longitude, resp.Standort.Latitude, 0.85];
    } else if (resp.Wert >= 40) {
        feld[i] = [resp.Standort.Longitude, resp.Standort.Latitude, 0.8];
    }
    else if (resp.Wert < 40) {
        feld[i] = [resp.Standort.Longitude, resp.Standort.Latitude, 0.75];
    }


}
//Funktion erstellt und fügt HeatMap in die Map ein
function loadHeatMap() {
    var heat = L.heatLayer(
        feld, { radius: 25, maxZoom: 14, blur: 15 });
    //points.push(heat);
    heatmap = heat;
    heat.addTo(map);
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
    pointsPoint.push(marker);
    punktLayer = marker;
    //Binde ein Popup an den Marker der die wichtigsten Informationen enthält
    marker.bindPopup("<b>Messung</b><br><b>Messzeitpunkt</b>: " + obj.ZeitpunktForJavascript + " <br>" +
        "<b>Lautstärke</b>: " + obj.Wert + " db").openPopup();
    marker.addTo(map);
}


function createPinTrack(obj) {

    var punkt = [obj.Messwerte[0].Standort.Longitude, obj.Messwerte[0].Standort.Latitude];
    //Erstelle eigenen Marker mit dem am Beginn deklarierten Objekt
    var werte = "";

    for (var i = 0; i < obj.Messwerte.length; i++) {
        werte = werte + obj.Messwerte[i].Wert + "db " + obj.Messwerte[i].ZeitpunktForJavascript + "<br>";
    }
    //Anzeige der einzelnen Werte
    var werteinGUI = "<button class='btn btn-primary' type='button' data-toggle='collapse' data-target='#collapseWerte' aria-expanded='false' aria-controls='collapseWerte'>" +
  " Zeige einzelne Werte" +
 "</button>" +
 "<div class='collapse' id='collapseWerte'>" +
   "<div class='well'>" +
     werte +
   "</div></div>";
    //var greenicon = new LeafIcon({ iconUrl: 'img/marker-icon_green.png' });
    var marker = new SoundCheckMarker(punkt, {
        title: obj.ID,
        Wert_Zeitpunkt: werte,
        icon: myIcon
    });
    pointsPointTrack.push(marker);
    punktLayerTrack = marker;

    //Binde ein Popup an den Marker der die wichtigsten Informationen enthält
    marker.bindPopup("<b>TrackingMessung</b><br>" +
        "<canvas id='can" + obj.ID + "'></canvas>" +
        "<br>" + werteinGUI).openPopup();
    //Wenn auf den Pin geklickt wird, dann zeichne das Diagram, damit die Canvas Objekte schon da sind.
    marker.on('click', function (e) {
        drawDiagram(obj);
    });

    marker.addTo(map);
}



function neuerFilter() {
    var startdatum = document.getElementById("startDatum").value;
    var enddatum = document.getElementById("endDatum").value;

    if (startdatum > enddatum) {
        alert("Fehler! Startdatum muss kleiner als Enddatum sein");
        return 0;
    }
    var obj = new Object();
    obj.startdatum = startdatum;
    obj.enddatum = enddatum;
    removeMarker();
    $.ajax({
        type: "POST",
        url: "Default.aspx/GetMessungenFiltered",
        data: JSON.stringify(obj),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            try {
                msgPoint = msg.d;
                //handleResponse(msg.d);

                removeMarker("punkte");
                
                removeOverlay();
                drawOverlay("heatmap", checkHeat);
                drawOverlay("punkte", checkPunkt);
                
                drawOverlay("anzahl", checkAnz);

            } catch (ex) {
                alert(ex);
            }
            //console.log(msg);
        }
    }
    );

    $.ajax({
        type: "POST",
        url: "Default.aspx/GetMessungenFilteredTrack",
        data: JSON.stringify(obj),
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            try {
                msgTrack = msg.d;
                //handleResponse(msg.d);

                
                removeMarker("track");
                
                drawOverlay("track", checkTrack);
                

            } catch (ex) {
                alert(ex);
            }
            //console.log(msg);
        }
    }
    );
}

function removeMarker(obj) {



    if (obj == "punkte") {
        for (var i = 0; i < pointsPoint.length; i++) {
            map.removeLayer(pointsPoint[i]);

        }
        pointsPoint = [];
    }

    else {
        for (var i = 0; i < pointsPointTrack.length; i++) {
            map.removeLayer(pointsPointTrack[i]);

        }
        pointsPointTrack = [];
    }
}

function removeOverlay() {
    if (feld.length > 0) {
        map.removeLayer(heatmap);
        feld = [];
    }


}

function drawOverlay(checkedAuswahl, isChecked) {



    if (checkedAuswahl == "track" && isChecked == true) {
        checkTrack = true;
    }
    else if (checkedAuswahl == "track") {
        checkTrack = false;
        
    }

    if (checkedAuswahl == "heatmap" && isChecked == true) {
        checkHeat = true;
    }
    else if (checkedAuswahl == "heatmap") {
        checkHeat = false;
    }

    if (checkedAuswahl == "punkte" && isChecked == true) {
        checkPunkt = true;
    }
    else if (checkedAuswahl == "punkte") {
        checkPunkt = false;
    }

    if (checkedAuswahl == "anzahl" && isChecked == true) {
        checkAnz = true;
    }
    else if (checkedAuswahl == "anzahl") {
        checkAnz = false;
    }

    

    if (checkedAuswahl == "mobile") {
        auswahl = "mobile";
        handleResponse(msgPoint);
    }

    else {
        if (isChecked) {
            if (checkedAuswahl == "track") {

                auswahl = checkedAuswahl;
                handleResponse(msgTrack);
            }
            else {

                auswahl = checkedAuswahl
                handleResponse(msgPoint);

            }
        }
        if (isChecked == false) {
            if (checkedAuswahl == "heatmap" || checkedAuswahl == ("anzahl")) {
                removeOverlay(heatmap);
            }

            else if (checkedAuswahl == "track") {
                removeMarker("track");

            }
            else {
                removeMarker("punkte");
            }
        }
    }
}