using System;
using System.Collections.Generic;
using System.Diagnostics;
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
        //Alle Messungen aus Österreich
        String requestString = "{\"request\": \"GetFeatureOfInterest\"," +
          "\"service\": \"SOS\"," +
          "\"version\": \"2.0.0\"," +
          "\"spatialFilter\": {" +
                "\"bbox\": {" +
                 " \"ref\": \"om:featureOfInterest/sams:SF_SpatialSamplingFeature/sams:shape\"," +
                  "\"value\": {" +
                    "\"type\": \"Polygon\"," +
                    "\"coordinates\": [" +
                      "[[" +
                          "46.28243," +
                          "8.75061" +
                        "],[" +
                          "49.06306925171648," +
                          "8.75061" +
                        "],[" +
                          "49.06306925171648," +
                          "17.523193359374996" +
                        "],[" +
                          "46.28243," +
                          "17.523193359374996" +
                        "],[" +
                          "46.28243," +
                          "8.75061" +
                        "]]]}}}}";
        return this.GetResponse(requestString);
    }

    public void GetObservation(String obID)
    {
        String requestStr = "{" +
                  "\"request\": \"GetObservation\"," +
                  "\"service\": \"SOS\"," +
                  "\"version\": \"2.0.0\"," +
                  "\"procedure\": \"DecibelSensor\"," +
                  "\"offering\": \"DecibelSensor\"," +
                  "\"observedProperty\": \"AmbientSound\"," +
                  "\"featureOfInterest\": \"" + obID + "\"}";

        String response = GetResponse(requestStr);

    }

    /// <summary>
    /// Methode sendet Request zum SOS Server
    /// @Author: Dominik Sammer
    /// @Date: 22.11.2015
    /// </summary>
    /// <param name="requestString"></param>
    /// <returns></returns>
    private String GetResponse(String requestString)
    {
        WebRequest request = (WebRequest)WebRequest.Create(new Uri(Server_Url));
        request.ContentType = "application/json";
        request.Method = "POST";

        using (var streamWriter = new StreamWriter(request.GetRequestStream()))
        {
            streamWriter.Write(requestString);
            streamWriter.Flush();
            streamWriter.Close();
        }

        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        String requestResult = "";
        using (var streamReader = new StreamReader(response.GetResponseStream()))
        {
            requestResult = streamReader.ReadToEnd();
        }
        return requestResult;
    }
}