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

    <style>
        .map {
            background: white;
        }
    </style>
    
    <script>
        function loadMap() {
            var capabilitiesUrl = 'http://www.basemap.at/wmts/1.0.0/WMTSCapabilities.xml';

            // HiDPI support:
            // * Use 'bmaphidpi' layer (pixel ratio 2) for device pixel ratio > 1
            // * Use 'geolandbasemap' layer (pixel ratio 1) for device pixel ratio == 1
            var hiDPI = ol.has.DEVICE_PIXEL_RATIO > 1;
            var layer = hiDPI ? 'bmaphidpi' : 'geolandbasemap';
            var tilePixelRatio = hiDPI ? 2 : 1;

            var map = new ol.Map({
                target: 'map',
                view: new ol.View({
                    center: [1823849, 6143760],
                    zoom: 11
                })
            });

            $.ajax(capabilitiesUrl).then(function(response) {
                var result = new ol.format.WMTSCapabilities().read(response);
                var options = ol.source.WMTS.optionsFromCapabilities(result, {
                    layer: layer,
                    matrixSet: 'google3857',
                    requestEncoding: 'REST',
                    style: 'normal'
                });
                options.tilePixelRatio = tilePixelRatio;
                map.addLayer(new ol.layer.Tile({
                    source: new ol.source.WMTS(options)
                }));
            });
        }
    </script>
    <script src="libraries/bootstrap/javascript/bootstrap.min.js"></script>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap-theme.min.css">

    <!-- Optional theme -->
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap.min.css">
</head>
<body onload="loadMap()">
    <form id="form1" runat="server">
        <div id="map" class="map"></div>
        
    </form>
</body>
</html>
