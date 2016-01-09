using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppCode;
using System.Web.Services;
using System.Web.Script.Serialization;

public partial class _Default : System.Web.UI.Page
{
    public Messungsliste Messungen { get; set; }
    public List<TimeTrackingMessung> TrackList { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    /// <summary>
    /// @Author: Dominik Sammer
    /// @Date: 23.10.2015
    /// Methode gibt Liste mit Standorten der aktuellen Liste zurück.
    /// Wird mit einem AJAX Call aufgerufen
    /// </summary>
    /// <returns></returns>
    [WebMethod]
    public static Messungsliste GetMessungen()
    {
        Messungsliste messungen = new Messungsliste();
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        messungen.LoadFromSOS();
        
        return messungen;
    }

    [WebMethod]
    public static List<TimeTrackingMessung> GetMessungenTimeTracking()
    {
        Messungsliste messungen = new Messungsliste();
        List<TimeTrackingMessung> trackmes = new List<TimeTrackingMessung>();
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        trackmes = messungen.LoadFromSOSTimeTracking();

        return trackmes;
    }

    /// <summary>
    /// @Author: Dominik Sammer
    /// @Date: 29.11.2015
    /// Endpoint für Filter Funktion
    /// </summary>
    /// <param name="startdatum">Ab wann Messungen kommen</param>
    /// <param name="enddatum">Bis wann Messungen kommen</param>
    /// <returns></returns>
    [WebMethod]
    public static Messungsliste GetMessungenFiltered(DateTime startdatum, DateTime enddatum)
    {
        if (startdatum > enddatum)
        {
            //Falsche Eingabe
            throw new Exception("Fehler! Enddatum kleiner als Startdatum");
        }
        Messungsliste messungen = new Messungsliste();
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        messungen.Clear();
        messungen.LoadFromSOS(startdatum, enddatum);

        return messungen;
    }

}