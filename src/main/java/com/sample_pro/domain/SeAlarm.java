package com.sample_pro.domain;

public class SeAlarm {
    private int    cookie;
    private String source;
    private int    areaMask;
    private String descString;
    private String pv;
    private String tripValue;
    private String timeAct;
    private String timeRtn;
    private String timeAck;

    public int    getCookie()     { return cookie; }
    public void   setCookie(int v){ cookie = v; }
    public String getSource()          { return source; }
    public void   setSource(String v)  { source = v; }
    public int    getAreaMask()        { return areaMask; }
    public void   setAreaMask(int v)   { areaMask = v; }
    public String getDescString()      { return descString; }
    public void   setDescString(String v){ descString = v; }
    public String getPv()              { return pv; }
    public void   setPv(String v)      { pv = v; }
    public String getTripValue()       { return tripValue; }
    public void   setTripValue(String v){ tripValue = v; }
    public String getTimeAct()         { return timeAct; }
    public void   setTimeAct(String v) { timeAct = v; }
    public String getTimeRtn()         { return timeRtn; }
    public void   setTimeRtn(String v) { timeRtn = v; }
    public String getTimeAck()         { return timeAck; }
    public void   setTimeAck(String v) { timeAck = v; }
}
