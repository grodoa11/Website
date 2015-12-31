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
    public List<Observation> observations { get; set; }

}

public class Observations
{
}

public class Observation
{
    public String type { get; set; }
    public Identifier identifier { get; set; }
    public String procedure { get; set; }
    public String offering { get; set; }
    public String observableProperty { get; set; }
    public FeatureOfInterest featureOfInterest { get; set; }
    public DateTime phenomenonTime { get; set; }
    public DateTime resultTime { get; set; }
    public Result result { get; set; }
    public List<Result> resultList { get; set; }
    public Name[] name { get; set; }
}

public class FeatureOfInterest
{
    public Identifier identifier { get; set; }
    public Identifier value { get; set; }
    public Geometry geometry { get; set; }
    public Name name { get; set; }
}

public class Name
{
    public String codespace { get; set;}
    public String value { get; set; }

}

public class Result
{
    public String uom { get; set; }
    public double value { get; set; }
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