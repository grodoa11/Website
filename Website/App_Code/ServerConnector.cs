using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

/// <summary>
/// @Author: Dominik Sammer
/// Datum: 14.10.2015
/// Klasse handelt Operationen mit der Cloud
/// </summary>
public class ServerConnector
{
    private static String Server_Url = "http://cyw.cti.ac.at:8181/sos/service";

    public ServerConnector()
    {
        
    }

    /// <summary>
    /// @Author: Dominik Sammer
    /// Date: 17.10.2015
    /// Methode gibt Feature of Interest zurück
    /// </summary>
    /// <returns>Json String with Feature of Interest</returns>
    public String GetFeatureOfInterestFromSOS()
    {
        String requestString = "{\"request\": \"GetFeatureOfInterest\",\"service\": \"SOS\"," +
                               " \"version\": \"2.0.0\"," +
                               " \"featureOfInterest\": \"http://www.52north.org/test/featureOfInterest/1\"," +
                               " \"observedProperty\": \"AmbientSound\"," +
                               " \"procedure\": \"DecibelSensor\"}";
        WebRequest request = (WebRequest) WebRequest.Create(new Uri(Server_Url));
        request.ContentType = "application/json";
        request.Method = "POST";

        using (var streamWriter = new StreamWriter(request.GetRequestStream()))
        {
            streamWriter.Write(requestString);
            streamWriter.Flush();
            streamWriter.Close();
        }

        HttpWebResponse response = (HttpWebResponse) request.GetResponse();
        String requestResult = "";
        using (var streamReader = new StreamReader(response.GetResponseStream()))
        {
            requestResult = streamReader.ReadToEnd();
        }

        return requestResult;
    }
}