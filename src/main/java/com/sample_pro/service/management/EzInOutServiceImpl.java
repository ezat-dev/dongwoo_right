package com.sample_pro.service.management;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sample_pro.dao.management.EzInOutDao;
import com.sample_pro.domain.CompanyEmployee;
import com.sample_pro.domain.EzInOutVisit;

@Service
public class EzInOutServiceImpl implements EzInOutService {

    @Autowired
    private EzInOutDao ezInOutDao;

    private void ensureTables() {
        ezInOutDao.ensureVisitTable();
        ezInOutDao.ensureVisitReasonColumns();
    }

    @Override
    public List<CompanyEmployee> getCompanyEmployeeList() {
        return ezInOutDao.selectCompanyEmployeeList();
    }

    @Override
    @Transactional
    public EzInOutVisit saveVisit(EzInOutVisit visit) {
        ensureTables();
        ezInOutDao.insertVisit(visit);
        return visit;
    }

    @Override
    public EzInOutVisit getVisitById(long visitId) {
        return ezInOutDao.getVisitById(visitId);
    }

    @Override
    public boolean verifyEmployeePin(String pin) {
        ezInOutDao.ensurePinTable();
        return ezInOutDao.countMatchingPin(pin) > 0;
    }

    @Override
    public boolean verifyEmployeePwNo(String pwNo) {
        return ezInOutDao.countMatchingPwNo(pwNo) > 0;
    }

    @Override
    public CompanyEmployee getEmployeeByPwNo(String pwNo) {
        return ezInOutDao.selectEmployeeByPwNo(pwNo);
    }

    @Override
    public List<Map<String,Object>> getSecurityEmployeeList() {
        ezInOutDao.ensureSecurityNotifyTable();
        return ezInOutDao.selectSecurityEmployeeList();
    }

    @Override
    @Transactional
    public void saveSecurityNotify(List<String> empIds) {
        // 모든 사원의 security_yn을 'N'으로 초기화
        List<Map<String,Object>> allEmps = ezInOutDao.selectSecurityEmployeeList();
        for (Map<String,Object> emp : allEmps) {
            int empId = Integer.parseInt(emp.get("emp_id").toString());
            ezInOutDao.updateSecurityNotify(empId, "N");
        }
        // 선택된 사원들의 security_yn을 'Y'로 설정
        if (empIds != null) {
            for (String empIdStr : empIds) {
                if (empIdStr != null && !empIdStr.isEmpty()) {
                    try {
                        int empId = Integer.parseInt(empIdStr);
                        ezInOutDao.updateSecurityNotify(empId, "Y");
                    } catch (NumberFormatException e) {
                        // 무시
                    }
                }
            }
        }
    }

    @Override
    public void logSecuritySensor(String sensorName, String sensorAddr, String status) {
        ezInOutDao.insertSecuritySensorLog(sensorName, sensorAddr, status);
    }

    @Override
    public List<java.util.Map<String,Object>> getSensorHistory(int limit) {
        return ezInOutDao.selectSecuritySensorHistory(limit);
    }
}
