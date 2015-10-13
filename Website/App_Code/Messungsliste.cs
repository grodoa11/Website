using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Zusammenfassungsbeschreibung für Messungsliste
/// </summary>
/// 

namespace AppCode
{
    public class Messungsliste:IList<Messwert>
    {
        private List<Messwert> m_Messwerte; 
        public Messungsliste()
        {
            m_Messwerte = new List<Messwert>();
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
            ///todo
            throw new NotImplementedException();
        }

        public void CopyTo(Messwert[] array, int arrayIndex)
        {
            //todo
            throw new NotImplementedException();
        }

        public bool Remove(Messwert item)
        {
            return m_Messwerte.Remove(item);
        }

        public int Count { get; }
        public bool IsReadOnly { get; }
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
    }

}
