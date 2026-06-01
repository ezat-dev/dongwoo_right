package com.sample_pro.domain;

public class InspectResult {
    private int    resultId;
    private String equipId;
    private String inspectYm;
    private int    inspectDay;
    private int    itemId;
    private String shift;   // D=주간, N=야간
    private String val;     // 수치값

    public int    getResultId()   { return resultId; }
    public String getEquipId()    { return equipId; }
    public String getInspectYm()  { return inspectYm; }
    public int    getInspectDay() { return inspectDay; }
    public int    getItemId()     { return itemId; }
    public String getShift()      { return shift; }
    public String getVal()        { return val; }

    public void setResultId(int v)      { this.resultId = v; }
    public void setEquipId(String v)    { this.equipId = v; }
    public void setInspectYm(String v)  { this.inspectYm = v; }
    public void setInspectDay(int v)    { this.inspectDay = v; }
    public void setItemId(int v)        { this.itemId = v; }
    public void setShift(String v)      { this.shift = v; }
    public void setVal(String v)        { this.val = v; }
}
