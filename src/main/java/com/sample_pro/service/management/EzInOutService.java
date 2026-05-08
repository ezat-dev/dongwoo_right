package com.sample_pro.service.management;

import java.util.List;

import com.sample_pro.domain.CompanyEmployee;
import com.sample_pro.domain.EzInOutVisit;

public interface EzInOutService {
    List<CompanyEmployee> getCompanyEmployeeList();
    EzInOutVisit saveVisit(EzInOutVisit visit);
    EzInOutVisit getVisitById(long visitId);
    boolean verifyEmployeePin(String pin);
    boolean verifyEmployeePwNo(String pwNo);
    CompanyEmployee getEmployeeByPwNo(String pwNo);
    // 경비 알림
    List<java.util.Map<String,Object>> getSecurityEmployeeList();
    void saveSecurityNotify(List<String> empIds);
    // 경비 센서 로그
    void logSecuritySensor(String sensorName, String sensorAddr, String status);
    List<java.util.Map<String,Object>> getSensorHistory(int limit);
}
