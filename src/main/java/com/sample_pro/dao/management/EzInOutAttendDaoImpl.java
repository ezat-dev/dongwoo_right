package com.sample_pro.dao.management;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.sample_pro.domain.EzInOutCardMaster;
import com.sample_pro.domain.EzInOutRecord;

@Repository
public class EzInOutAttendDaoImpl implements EzInOutAttendDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<EzInOutCardMaster> selectCardMasterList() {
        return sqlSession.selectList("EzInOutAttendMapper.selectCardMasterList");
    }

    @Override
    public EzInOutCardMaster selectCardMasterByCode(String cardCode) {
        return sqlSession.selectOne("EzInOutAttendMapper.selectCardMasterByCode", cardCode);
    }

    @Override
    public int countRecentDuplicate(Map<String, Object> params) {
        Integer cnt = sqlSession.selectOne("EzInOutAttendMapper.countRecentDuplicate", params);
        return cnt != null ? cnt : 0;
    }

    @Override
    public void insertRecord(EzInOutRecord record) {
        sqlSession.insert("EzInOutAttendMapper.insertRecord", record);
    }

    @Override
    public List<EzInOutRecord> selectRecentRecords(int limit) {
        return sqlSession.selectList("EzInOutAttendMapper.selectRecentRecords", limit);
    }

    @Override
    public List<EzInOutRecord> selectRecordsByCondition(Map<String, Object> params) {
        return sqlSession.selectList("EzInOutAttendMapper.selectRecordsByCondition", params);
    }

    @Override
    public List<Map<String, Object>> selectEmpListInPeriod(Map<String, Object> params) {
        return sqlSession.selectList("EzInOutAttendMapper.selectEmpListInPeriod", params);
    }

    @Override
    public List<EzInOutRecord> selectAllRecordsForExcel(Map<String, Object> params) {
        return sqlSession.selectList("EzInOutAttendMapper.selectAllRecordsForExcel", params);
    }

    @Override
    public List<Map<String, Object>> selectDailyRecords(Map<String, Object> params) {
        return sqlSession.selectList("EzInOutAttendMapper.selectDailyRecords", params);
    }
}
