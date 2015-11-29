using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AppCode
{
    /// <summary>
    /// Created by: Dominik Sammer
    /// 02.08.2015
    /// Enum mit den Arten von Messungen
    /// </summary>
    public enum ArtDerMessung
    {
        Einfachmessung,
        Loggingmessung
    }

    /// <summary>
    /// Created by: Dominik Sammer
    /// 02.08.2015
    /// Klasse für den Messwert
    /// </summary>
    public class Messwert
    {
        public Double Wert { get; set; }
        public DateTime ZeitpunktDerMessung { get; set; }
        public String ZeitpunktForJavascript { get; set; }
        public ArtDerMessung ArtDerMessung { get; set; }
        public Standort Standort { get; set; }
        public int ID { get; set; }
        public String Beschreibung { get; set; }

        public override string ToString()
        {
            return String.Format("Beschreibung: {0}, Messung: {1}, Zeitpunkt: {2}, Art der Messung: {3}",Beschreibung, Wert, ZeitpunktDerMessung, ArtDerMessung.ToString());
        }
    }

}
