package com.sample_pro.domain;

public class ConsumableLedgerHistory {
    private Long   id;
    private Long   ledgerId;
    private String category;   // JOIN용
    private String itemName;   // JOIN용
    private String type;       // IN / OUT
    private String qty;
    private String remark;
    private String userName;
    private String regDate;

    public Long   getId()               { return id; }
    public void   setId(Long v)         { id = v; }
    public Long   getLedgerId()         { return ledgerId; }
    public void   setLedgerId(Long v)   { ledgerId = v; }
    public String getCategory()         { return category; }
    public void   setCategory(String v) { category = v; }
    public String getItemName()         { return itemName; }
    public void   setItemName(String v) { itemName = v; }
    public String getType()             { return type; }
    public void   setType(String v)     { type = v; }
    public String getQty()              { return qty; }
    public void   setQty(String v)      { qty = v; }
    public String getRemark()           { return remark; }
    public void   setRemark(String v)   { remark = v; }
    public String getUserName()         { return userName; }
    public void   setUserName(String v) { userName = v; }
    public String getRegDate()          { return regDate; }
    public void   setRegDate(String v)  { regDate = v; }
}
