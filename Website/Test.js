
function initMap(){
var latitude = 5964561.74645;
var longitude = 1539315.13234;
var zoom = 9;

//Karte erstellen und auf das div "map" binden. In der SetView werden Longitude und Latitude angegeben und bei welchen Zoom man beginnt
    map = L.map('map', {
        zoomControl: false
    }).setView([longitude, latitude], zoom);

    //In das richtige Fromat EPSG 3857 umrechnen
    var point = new L.Point(longitude, latitude); // Lon/Lat
    var earthRadius = 6378137;
    var latlng = L.Projection.SphericalMercator.unproject(point.divideBy(earthRadius));

    map.panTo(new L.LatLng(latlng.lat, latlng.lng));

    //Hier wird angegeben von wo der KartenLayer geladen werden soll
    L.tileLayer('http://maps.wien.gv.at/basemap/geolandbasemap/normal/google3857/{z}/{y}/{x}.png', {
        attribution: 'Karte: <a href="http://basemap.at" target="_blank">basemap.at</a>, <a href="http://creativecommons.org/licenses/by/3.0/at/deed.de"' +
            ' target="_blank">CC-BY 3.0</a> | <a id="legalinformation">Legal Information</a>',
        tms: false,
        detectRetina: true
    }).addTo(map);



    return map;
    }