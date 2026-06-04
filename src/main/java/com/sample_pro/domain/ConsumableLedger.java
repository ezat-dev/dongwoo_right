package com.sample_pro.domain;

public class ConsumableLedger {
    private Long   id;
    private String category;
    private String itemName;
    private String packageUnit;
    private String stockQty;
    private String stockUnit;
    private String safetyQty;
    private String safetyUnit;
    private String remark;
    private int    sortOrder;
    private String useYn;
    private String regDate;
    private String updateDate;

    public Long   getId()               { return id; }
    public void   setId(Long v)         { id = v; }
    public String getCategory()         { return category; }
    public void   setCategory(String v) { category = v; }
    public String getItemName()         { return itemName; }
    public void   setItemName(String v) { itemName = v; }
    public String getPackageUnit()           { return packageUnit; }
    public void   setPackageUnit(String v)   { packageUnit = v; }
    public String getStockQty()         { return stockQty; }
    public void   setStockQty(String v) { stockQty = v; }
    public String getStockUnit()        { return stockUnit; }
    public void   setStockUnit(String v){ stockUnit = v; }
    public String getSafetyQty()        { return safetyQty; }
    public void   setSafetyQty(String v){ safetyQty = v; }
    public String getSafetyUnit()       { return safetyUnit; }
    public void   setSafetyUnit(String v){ safetyUnit = v; }
    public String getRemark()           { return remark; }
    public void   setRemark(String v)   { remark = v; }
    public int    getSortOrder()        { return sortOrder; }
    public void   setSortOrder(int v)   { sortOrder = v; }
    public String getUseYn()            { return useYn; }
    public void   setUseYn(String v)    { useYn = v; }
    public String getRegDate()          { return regDate; }
    public void   setRegDate(String v)  { regDate = v; }
    public String getUpdateDate()       { return updateDate; }
    public void   setUpdateDate(String v){ updateDate = v; }
}
