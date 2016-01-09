using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// TimeTrackingMessung
/// </summary>

namespace AppCode
{
    public class TimeTrackingMessung
    {
        public List<Messwert> Messwerte { get; set; }
        public String ID { get; set; }
        public String Beschreibung { get; set; }


        public TimeTrackingMessung()
        {
            
        }


    }
}