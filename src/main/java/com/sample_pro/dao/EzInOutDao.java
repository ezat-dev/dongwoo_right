package com.sample_pro.dao;

import java.util.List;

import com.sample_pro.domain.CompanyEmployee;
import com.sample_pro.domain.EzInOutVisit;

public interface EzInOutDao {
    void ensureVisitTable();
    void ensureVisitReasonColumns();
    void ensurePinTable();
    List<CompanyEmployee> selectCompanyEmployeeList();
    void insertVisit(EzInOutVisit visit);
    EzInOutVisit getVisitById(long visitId);
    int countMatchingPin(String pin);
    int countMatchingPwNo(String pwNo);
    CompanyEmployee selectEmployeeByPwNo(String pwNo);
    // 경비 알림
    void ensureSecurityNotifyTable();
    List<java.util.Map<String,Object>> selectSecurityEmployeeList();
    void updateSecurityNotify(int empId, String securityYn);
    // 경비 센서 로그
    void insertSecuritySensorLog(String sensorName, String sensorAddr, String status);
    List<java.util.Map<String,Object>> selectSecuritySensorHistory(int limit);
}
