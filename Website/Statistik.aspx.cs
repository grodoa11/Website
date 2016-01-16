using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppCode;

public partial class Statistik : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DateTime startdatum;
            DateTime enddatum;

            startdatum = new DateTime(2016, 01, 01);
            enddatum = DateTime.Now;

            Messungsliste messungen = new Messungsliste();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            messungen.Clear();
            messungen.LoadFromSOS(startdatum, enddatum);

            DateTime curDate = startdatum;

            int anzDays = (int) (enddatum - startdatum).TotalDays;

            if (messungen.Count > 0)
            {
                messungen.Sort();

                String retStr = GetStringForJS(messungen, anzDays, curDate);
                hdfAnzahlMessungen.Value = retStr;
            }
            else
            {
                hdfAnzahlMessungen.Value = "";
            }
        }
    }

    private static string GetStringForJS(Messungsliste messungen, int anzDays, DateTime curDate)
    {
        int zaehlMesswerte = 0;
        int anzahl = 0;
        string retStr = "";
        Messwert letzterMesswert = messungen[0];
        for (int i = 0; i < anzDays; i = i)
        {
            if (messungen.Count > zaehlMesswerte &&
                messungen[zaehlMesswerte].ZeitpunktDerMessung.ToShortDateString() == curDate.ToShortDateString())
            {
                Messwert mw = messungen[zaehlMesswerte];
                if (mw.ZeitpunktDerMessung.ToShortDateString() ==
                    letzterMesswert.ZeitpunktDerMessung.ToShortDateString())
                {
                    anzahl++;
                    letzterMesswert = mw;
                }

                zaehlMesswerte++;
            }
            else
            {
                Messwert mw = letzterMesswert;
                if (messungen.Count > zaehlMesswerte)
                    mw = messungen[zaehlMesswerte];
                retStr += letzterMesswert.ZeitpunktDerMessung.ToShortDateString() + "_" + anzahl + "}";
                anzahl = 0;
                letzterMesswert = mw;
                curDate = curDate.AddDays(1);
                i++;
            }
        }
        return retStr;
    }

    [WebMethod]
    public static String ChangeDate(DateTime dt1, DateTime dt2)
    {
        Messungsliste liste = new Messungsliste();
        liste.LoadFromSOS(dt1, dt2);
        liste.Sort();
        int anzDays = (int)(dt2 - dt1).TotalDays;
        return Statistik.GetStringForJS(liste, anzDays, dt1);
    }
}