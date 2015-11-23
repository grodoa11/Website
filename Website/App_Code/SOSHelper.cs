using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// @Author: Dominik Sammer
/// Datum: 17.10.2015
/// Klasse, um aus dem JSON String ein Objekt zu machen
/// </summary>
public class SOSHelper
{
    public String request { get; set; }
    public string version { get; set; }
    public string service { get; set; }
    public List<FeatureOfInterest> featureOfInterest { get; set; }

}

public class FeatureOfInterest
{
    public Identifier identifier { get; set; }
    public Identifier value { get; set; }
    public Geometry geometry { get; set; }

}

public class Identifier
{
    public String codespace { get; set; }
    public String value { get; set; }
}

public class Geometry
{
    public String type { get; set; }
    public List<Single> coordinates { get; set; }
}