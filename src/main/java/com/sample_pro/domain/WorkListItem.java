package com.sample_pro.domain;

public class WorkListItem {
    private Integer statusSeq;
    private String  tday;
    private String  workIndctNum;
    private String  custNm;
    private String  equtCd;
    private String  prodNm;
    private String  mainWorkIndctNum;
    private String  insertDttm;
    private String  scanStartDttm;
    private String  startDttm;
    private String  endDttm;

    public Integer getStatusSeq()            { return statusSeq; }
    public void setStatusSeq(Integer v)      { this.statusSeq = v; }
    public String getTday()                  { return tday; }
    public void setTday(String v)            { this.tday = v; }
    public String getWorkIndctNum()          { return workIndctNum; }
    public void setWorkIndctNum(String v)    { this.workIndctNum = v; }
    public String getCustNm()                { return custNm; }
    public void setCustNm(String v)          { this.custNm = v; }
    public String getEqutCd()                { return equtCd; }
    public void setEqutCd(String v)          { this.equtCd = v; }
    public String getProdNm()                { return prodNm; }
    public void setProdNm(String v)          { this.prodNm = v; }
    public String getMainWorkIndctNum()      { return mainWorkIndctNum; }
    public void setMainWorkIndctNum(String v){ this.mainWorkIndctNum = v; }
    public String getInsertDttm()            { return insertDttm; }
    public void setInsertDttm(String v)      { this.insertDttm = v; }
    public String getScanStartDttm()         { return scanStartDttm; }
    public void setScanStartDttm(String v)   { this.scanStartDttm = v; }
    public String getStartDttm()             { return startDttm; }
    public void setStartDttm(String v)       { this.startDttm = v; }
    public String getEndDttm()               { return endDttm; }
    public void setEndDttm(String v)         { this.endDttm = v; }
}
