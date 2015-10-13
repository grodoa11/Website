using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppCode
{
    public class Standort
    {
        public double Longitude { get; set; }
        public double Latitude { get; set; }
        public String OrtBezeichnung { get; set; }

        public Standort()
        {

        }

        public Standort(double latitude, double longitude)
        {
            Longitude = longitude;
            Latitude = latitude;
        }

        public Standort(double longitude, double latitude, String bez):this(latitude, longitude)
        {
            OrtBezeichnung = bez;
        }
        public override string ToString()
        {
            return Longitude + " " + Latitude;
        }
    }
}
