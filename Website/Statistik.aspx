<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Statistik.aspx.cs" Inherits="Statistik" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>SoundCheck | Statistiken</title>
    
    <script src="http://openlayers.org/api/OpenLayers.js"></script>
    <script src="JScript.js"></script>
    <script src="libraries/chart/Chart.js"></script>
    <script src="https://code.jquery.com/jquery-1.11.2.min.js"></script>

    <script src="libraries/bootstrap/javascript/bootstrap.min.js"></script>
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="libraries/bootstrap/css/bootstrap.min.css">
    
    <script>
        var DayAnzahl = function (date, anzahl) {
            this.date = date;
            this.anzahl = anzahl;
        }
        function loadPage() {
            var anz = document.getElementById("hdfAnzahlMessungen").value;
            var gesp = anz.split("}");
            var obj = [];
            for (var i = 0; i < gesp.length-1; i++) {
                var elements = gesp[i].split('_');
                obj[i] = new DayAnzahl(elements[0], elements[1]);
            }

            console.log(obj);
            drawDiagram(obj);
        }

        function enterFilter() {
            var startdatum = document.getElementById("inpDateAuswahlVon").value;
            var enddatum = document.getElementById("inpDateAuswahlBis").value;

            if (startdatum > enddatum) {
                alert("Fehler! Startdatum muss kleiner als Enddatum sein");
                return 0;
            }
            var obj = new Object();
            obj.dt1 = startdatum;
            obj.dt2 = enddatum;

            $.ajax({
                type: "POST",
                url: "Statistik.aspx/ChangeDate",
                data: JSON.stringify(obj),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(msg) {
                    try {
                        var gesp = msg.d.split("}");
                        var obj = [];
                        for (var i = 0; i < gesp.length - 1; i++) {
                            var elements = gesp[i].split('_');
                            obj[i] = new DayAnzahl(elements[0], elements[1]);
                        }
                        drawDiagram(msg);
                    } catch (ex) {
                        alert(ex);
                    }
                    //console.log(msg);
                }

            });
        }

        function drawDiagram(obj) {
            console.log(obj);
            var labs = [];
            var werte = [];
            var gesamtWerte = 0;
            for (var i = 0; i < obj.length; i++) {
                labs[i] = obj[i].date;
                gesamtWerte += parseInt(obj[i].anzahl);
                werte[i] = gesamtWerte;
            }
            document.getElementById("chartAnzMessungen").width = screen.width-screen.width*0.10;
            var diagramCanvas = document.getElementById("chartAnzMessungen").getContext("2d");

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


            var myLineChart = new Chart(diagramCanvas).Line(data);
        }
    </script>
</head>
<body onload="loadPage()">
        <!-- Navigation -->
    <nav class="navbar navbar-inverse">
        <div class="container-fluid">
            <div class="navbar-header">
                <a class="navbar-brand" href="#">Soundcheck</a>
            </div>
            <div>
                <ul class="nav navbar-nav">
                    <li ><a href="Default.aspx">Lärmkarte</a></li>
                    <li><a href="#" class="active">Statistik</a></li>
                    <li><a href="Info.html">Info</a></li>
                </ul>
            </div>
        </div>
    </nav>

    <div>
        <h1>Anzahl Messungen</h1>
        
       <%-- <table width="30%">
            <tr>
                <td colspan="2"><h2>Zeitraum auswählen</h2></td>
            </tr>
            <tr>
                <td>
                    Von <input type="date" id="inpDateAuswahlVon"/>
                </td>
                <td>
                    Bis <input type="date" id="inpDateAuswahlBis"/>
                </td>
                <td>
                    <button class="btn" onclick="enterFilter()">Filtern</button>
                </td>
            </tr>
        </table>--%>
        <canvas id="chartAnzMessungen" width="500" height="500"></canvas>
    </div>
        
    <form id="form1" runat="server">
        <asp:HiddenField runat="server" ID="hdfAnzahlMessungen"/>
    </form>
</body>
</html>
