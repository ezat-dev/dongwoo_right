package com.sample_pro.domain;

public class FProof {
    private int    id;
    private int    tagId;
    private String plcId;
    private String grade;       // A / B / C
    private String checkItem;   // 방호항목
    private String riskFactor;  // 위험요소
    private String measure;     // 방호수단
    private int    score;       // 이행점수 0~100
    private int    status;      // 0=미이행 1=이행
    private String checkDate;   // 최근 점검일
    private String memo;
    private String createdAt;
    private String updatedAt;

    public int    getId()           { return id; }
    public void   setId(int id)     { this.id = id; }

    public int    getTagId()                 { return tagId; }
    public void   setTagId(int tagId)        { this.tagId = tagId; }

    public String getPlcId()                 { return plcId; }
    public void   setPlcId(String plcId)     { this.plcId = plcId; }

    public String getGrade()                 { return grade; }
    public void   setGrade(String grade)     { this.grade = grade; }

    public String getCheckItem()             { return checkItem; }
    public void   setCheckItem(String v)     { this.checkItem = v; }

    public String getRiskFactor()            { return riskFactor; }
    public void   setRiskFactor(String v)    { this.riskFactor = v; }

    public String getMeasure()               { return measure; }
    public void   setMeasure(String v)       { this.measure = v; }

    public int    getScore()                 { return score; }
    public void   setScore(int score)        { this.score = score; }

    public int    getStatus()                { return status; }
    public void   setStatus(int status)      { this.status = status; }

    public String getCheckDate()             { return checkDate; }
    public void   setCheckDate(String v)     { this.checkDate = v; }

    public String getMemo()                  { return memo; }
    public void   setMemo(String memo)       { this.memo = memo; }

    public String getCreatedAt()             { return createdAt; }
    public void   setCreatedAt(String v)     { this.createdAt = v; }

    public String getUpdatedAt()             { return updatedAt; }
    public void   setUpdatedAt(String v)     { this.updatedAt = v; }
}
