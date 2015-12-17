using AppCode;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Mobile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    public Messungsliste Messungen { get; set; }

    public static Messungsliste GetMessungen()
    {
        Messungsliste messungen = new Messungsliste();
        JavaScriptSerializer serializer = new JavaScriptSerializer();
        messungen.LoadFromSOS();
        
        return messungen;
    }
}