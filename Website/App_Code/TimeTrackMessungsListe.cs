using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Summary description for TimeTrackMessungsListe
/// </summary>
/// 
namespace AppCode
{
    public class TimeTrackMessungsListe:IList<TimeTrackingMessung>
    {

        private List<TimeTrackingMessung> m_track;
        private ServerConnector m_Con;
        public TimeTrackMessungsListe()
        {
            m_Con = new ServerConnector();
            m_track = new List<TimeTrackingMessung>();
        }

        public TimeTrackingMessung this[int index]
        {
            get
            {
                throw new NotImplementedException();
            }

            set
            {
                throw new NotImplementedException();
            }
        }

        public IEnumerator<TimeTrackingMessung> GetEnumerator()
        {
            return m_track.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return m_track.GetEnumerator();
        }


        public int Count
        {
            get { return m_track.Count; }
        }

        public bool IsReadOnly
        {
            get
            {
                throw new NotImplementedException();
            }
        }

        public void Add(TimeTrackingMessung item)
        {
            m_track.Add(item);
        }

        public void Clear()
        {
            m_track.Clear();
        }

        public bool Contains(TimeTrackingMessung item)
        {
            return true;
        }

        public void CopyTo(TimeTrackingMessung[] array, int arrayIndex)
        {
            throw new NotImplementedException();
        }



        public int IndexOf(TimeTrackingMessung item)
        {
            return m_track.IndexOf(item);
        }

        public void Insert(int index, TimeTrackingMessung item)
        {
            m_track.Insert(index, item);
        }

        public bool Remove(TimeTrackingMessung item)
        {
            return m_track.Remove(item);
        }

        public void RemoveAt(int index)
        {
            m_track.RemoveAt(index);
        }

        public List<TimeTrackingMessung> Filter(DateTime startDate, DateTime enddate)
        {
            List<TimeTrackingMessung> messungenGefiltert = new List<TimeTrackingMessung>();
            foreach (TimeTrackingMessung tm in m_track)
            {
                if (tm.Messwerte[0].ZeitpunktDerMessung > startDate && tm.Messwerte[0].ZeitpunktDerMessung < enddate)
                {
                    messungenGefiltert.Add(tm);
                }
            }
            return messungenGefiltert;
        }

        /// <summary>
        /// Methode ladet SOS Werte ab dem 1.1.2015
        /// </summary>
        

        public void LoadFromSOSTimeTracking()
        {
            GetObservationTimeTracking(new DateTime(2015, 01, 01), DateTime.Now);
            
        }

        public void LoadFromSOSTimeTracking(DateTime startDate, DateTime endDate)
        {
            GetObservationTimeTracking(startDate, endDate);
        }


        private void GetObservationTimeTracking(DateTime startDate, DateTime endDate)
        {
            String jsonStr = m_Con.GetObservationTimeTracking(startDate, endDate);
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            SOSHelper helper = serializer.Deserialize<SOSHelper>(jsonStr);
            List<Messwert> messwertlist = new List<Messwert>();
            String allResponses = "";
            try
            {

                foreach (Observation observation in helper.observations)
                {
                    object[] allnamparts = ((object[])observation.featureOfInterest.name);
                    if (allnamparts.Length <= 3)
                    {
                        //allResponses += m_Con.GetObservation(featureOfInterest.identifier.value);
                        List<Single> geometry = observation.featureOfInterest.geometry.coordinates;
                        Single x = geometry[0];
                        Single y = geometry[1];
                        Messwert mw = new Messwert();
                        mw.Standort = new Standort { Longitude = x, Latitude = y };
                        mw.ArtDerMessung = ArtDerMessung.Loggingmessung;
                        mw.ZeitpunktDerMessung = observation.resultTime;
                        mw.ZeitpunktForJavascript = observation.resultTime.ToShortDateString() + " " +
                                                    observation.resultTime.ToShortTimeString();
                        mw.Wert = observation.result.value;
                        Dictionary<String, object> dict = ((Dictionary<String, object>)allnamparts[2]);
                        mw.ID = allnamparts[0].ToString() + allnamparts[1].ToString() + "" + dict.SingleOrDefault(p => p.Key == "value").Value;
                        //mw.ZeitpunktDerMessung = observation.featureOfInterest.resultTime;
                        messwertlist.Add(mw);
                    }

                }

                foreach (Messwert mesw in messwertlist)
                {
                    if (m_track.Where(p => p.ID == mesw.ID).FirstOrDefault() == null)
                    {
                        m_track.Add(new TimeTrackingMessung
                        {
                            ID = mesw.ID,
                            Beschreibung = mesw.Beschreibung,
                            Messwerte = new List<Messwert>() {
                            mesw
                        }
                        });
                    }

                    else
                    {
                        m_track.Where(p => p.ID == mesw.ID).FirstOrDefault().Messwerte.Add(mesw);
                    }

                }
            }
            catch (Exception e)
            {

                Console.WriteLine(e.ToString());
            }
        }



    

}
}