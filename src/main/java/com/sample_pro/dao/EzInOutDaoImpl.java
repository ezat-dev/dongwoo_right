package com.sample_pro.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.sample_pro.domain.CompanyEmployee;
import com.sample_pro.domain.EzInOutVisit;

@Repository
public class EzInOutDaoImpl implements EzInOutDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public void ensureVisitTable() {
        sqlSession.update("EzInOutMapper.ensureVisitTable");
    }

    @Override
    public void ensureVisitReasonColumns() {
        sqlSession.update("EzInOutMapper.ensureVisitReasonColumns");
    }

    @Override
    public List<CompanyEmployee> selectCompanyEmployeeList() {
        return sqlSession.selectList("EzInOutMapper.selectCompanyEmployeeList");
    }

    @Override
    public void insertVisit(EzInOutVisit visit) {
        sqlSession.insert("EzInOutMapper.insertVisit", visit);
    }

    @Override
    public EzInOutVisit getVisitById(long visitId) {
        return sqlSession.selectOne("EzInOutMapper.getVisitById", visitId);
    }

    @Override
    public void ensurePinTable() {
        sqlSession.update("EzInOutMapper.ensurePinTable");
    }

    @Override
    public int countMatchingPin(String pin) {
        Integer count = sqlSession.selectOne("EzInOutMapper.countMatchingPin", pin);
        return count != null ? count : 0;
    }

    @Override
    public int countMatchingPwNo(String pwNo) {
        Integer count = sqlSession.selectOne("EzInOutMapper.countMatchingPwNo", pwNo);
        return count != null ? count : 0;
    }

    @Override
    public CompanyEmployee selectEmployeeByPwNo(String pwNo) {
        return sqlSession.selectOne("EzInOutMapper.selectEmployeeByPwNo", pwNo);
    }

    @Override
    public void ensureSecurityNotifyTable() {
        sqlSession.update("EzInOutMapper.ensureSecurityNotifyTable");
    }

    @Override
    public List<Map<String,Object>> selectSecurityEmployeeList() {
        return sqlSession.selectList("EzInOutMapper.selectSecurityEmployeeList");
    }

    @Override
    public void updateSecurityNotify(int empId, String securityYn) {
        Map<String, Object> param = new HashMap<>();
        param.put("emp_id", empId);
        param.put("security_yn", securityYn);
        sqlSession.update("EzInOutMapper.updateSecurityNotify", param);
    }

    @Override
    public void insertSecuritySensorLog(String sensorName, String sensorAddr, String status) {
        Map<String, Object> param = new HashMap<>();
        param.put("sensor_name", sensorName);
        param.put("sensor_addr", sensorAddr);
        param.put("status", status);
        sqlSession.insert("EzInOutMapper.insertSecuritySensorLog", param);
    }

    @Override
    public List<java.util.Map<String, Object>> selectSecuritySensorHistory(int limit) {
        return sqlSession.selectList("EzInOutMapper.selectSecuritySensorHistory", limit);
    }
}
