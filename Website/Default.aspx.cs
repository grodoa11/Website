using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using AppCode;

public partial class _Default : System.Web.UI.Page
{
    private Messungsliste m_Liste;

    protected void Page_Load(object sender, EventArgs e)
    {
        m_Liste = new Messungsliste();
        List<FeatureOfInterest> featureOfInterests = m_Liste.LoadFromSOS();

        foreach (FeatureOfInterest featureOfInterest in featureOfInterests)
        {
            List<Single> geometry = featureOfInterest.geometry.coordinates;
            Single x = geometry[0];
            Single y = geometry[1];
            Response.Write("X: " + x + " Y: " + y + "<br>");

        }
    }

}