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

}