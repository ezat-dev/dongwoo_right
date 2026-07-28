package com.sample_pro.domain;

public class InspectItem {
    private int    itemId;
    private String equipId;
    private String itemName;
    private String itemStd;
    private int    sortOrder;
    private String applyFromYm;
    private String delFromYm;
    private String imgFile;
    private String inputType;   // NUM(기본) 또는 OX

    public int    getItemId()       { return itemId; }
    public String getEquipId()      { return equipId; }
    public String getItemName()     { return itemName; }
    public String getItemStd()      { return itemStd; }
    public int    getSortOrder()    { return sortOrder; }
    public String getApplyFromYm()  { return applyFromYm; }
    public String getDelFromYm()    { return delFromYm; }
    public String getImgFile()      { return imgFile; }
    public String getInputType()    { return inputType; }

    public void setItemId(int itemId)           { this.itemId = itemId; }
    public void setEquipId(String equipId)       { this.equipId = equipId; }
    public void setItemName(String itemName)     { this.itemName = itemName; }
    public void setItemStd(String itemStd)       { this.itemStd = itemStd; }
    public void setSortOrder(int sortOrder)      { this.sortOrder = sortOrder; }
    public void setApplyFromYm(String v)         { this.applyFromYm = v; }
    public void setDelFromYm(String v)           { this.delFromYm = v; }
    public void setImgFile(String v)             { this.imgFile = v; }
    public void setInputType(String v)           { this.inputType = v; }
}
