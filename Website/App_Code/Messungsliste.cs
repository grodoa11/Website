using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.ServiceModel.Description;
using System.Web;
using System.Web.Script.Serialization;

/// <summary>
/// Zusammenfassungsbeschreibung für Messungsliste
/// </summary>
/// 

namespace AppCode
{
    public class Messungsliste : IList<Messwert>
    {
        private List<Messwert> m_Messwerte;
        private ServerConnector m_Con;

        public Messungsliste()
        {
            m_Messwerte = new List<Messwert>();
            m_Con = new ServerConnector();
        }

        public IEnumerator<Messwert> GetEnumerator()
        {
            return m_Messwerte.GetEnumerator();
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return m_Messwerte.GetEnumerator();
        }

        public void Add(Messwert item)
        {
            m_Messwerte.Add(item);
        }

        public void Clear()
        {
            m_Messwerte.Clear();
        }

        public bool Contains(Messwert item)
        {
            //todo
            return true;
        }

        public void CopyTo(Messwert[] array, int arrayIndex)
        {
            //todo
            
        }

        public bool Remove(Messwert item)
        {
            return m_Messwerte.Remove(item);
        }

        public int Count
        {
            get { return m_Messwerte.Count; }
        }

        public bool IsReadOnly { get { return false; } }
        public int IndexOf(Messwert item)
        {
            return m_Messwerte.IndexOf(item);
        }

        public void Insert(int index, Messwert item)
        {
            m_Messwerte.Insert(index, item);
        }

        public void RemoveAt(int index)
        {
            m_Messwerte.RemoveAt(index);
        }

        public Messwert this[int index]
        {
            get { return m_Messwerte[index]; }
            set { m_Messwerte[index] = value; }
        }

        public List<FeatureOfInterest> LoadFromSOS()
        {
            String jsonStr = m_Con.GetFeatureOfInterestFromSOS();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            SOSHelper helper = serializer.Deserialize<SOSHelper>(jsonStr);
            return helper.featureOfInterest;
        }
    }

}
