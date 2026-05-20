package com.sample_pro.domain;

public class NowWorkItem {
    private int    seq;
    private int    pageNo;
    private String equipCd;
    private String equipNm;
    private String roomNm;
    private int    rowSort;
    private String custNm;
    private String prodNm;
    private String lotNo;
    private String updDt;

    public int    getSeq()     { return seq; }
    public void   setSeq(int seq) { this.seq = seq; }

    public int    getPageNo()  { return pageNo; }
    public void   setPageNo(int pageNo) { this.pageNo = pageNo; }

    public String getEquipCd() { return equipCd; }
    public void   setEquipCd(String equipCd) { this.equipCd = equipCd; }

    public String getEquipNm() { return equipNm; }
    public void   setEquipNm(String equipNm) { this.equipNm = equipNm; }

    public String getRoomNm()  { return roomNm; }
    public void   setRoomNm(String roomNm) { this.roomNm = roomNm; }

    public int    getRowSort() { return rowSort; }
    public void   setRowSort(int rowSort) { this.rowSort = rowSort; }

    public String getCustNm()  { return custNm; }
    public void   setCustNm(String custNm) { this.custNm = custNm; }

    public String getProdNm()  { return prodNm; }
    public void   setProdNm(String prodNm) { this.prodNm = prodNm; }

    public String getLotNo()   { return lotNo; }
    public void   setLotNo(String lotNo) { this.lotNo = lotNo; }

    public String getUpdDt()   { return updDt; }
    public void   setUpdDt(String updDt) { this.updDt = updDt; }
}
