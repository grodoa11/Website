using AppCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Mobile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        String lat = Request.QueryString.Get("lat");
        String lon = Request.QueryString.Get("long");

        if (lat == null || lon == null)
        {
            hiddenFieldLat.Value = "0";
            hiddenFieldLon.Value = "0";
        }
        else { 
            hiddenFieldLat.Value = "" + lat;
            hiddenFieldLon.Value = "" + lon;
        }
}
    public Messungsliste Messungen { get; set; }

    [WebMethod]
    public static Messungsliste GetMessungen()
    {
        Messungsliste messungen = new Messungsliste();
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        messungen.LoadFromSOS();
        
        return messungen;
    }
}