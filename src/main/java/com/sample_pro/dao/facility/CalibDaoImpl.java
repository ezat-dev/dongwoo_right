package com.sample_pro.dao.facility;

import com.sample_pro.domain.CalibThermocouple;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class CalibDaoImpl implements CalibDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<CalibThermocouple> selectList(Map<String, Object> params) {
        return sqlSession.selectList("CalibMapper.selectList", params);
    }

    @Override
    public CalibThermocouple selectById(int calibId) {
        return sqlSession.selectOne("CalibMapper.selectById", calibId);
    }

    @Override
    public List<CalibThermocouple> selectDdayAlerts() {
        return sqlSession.selectList("CalibMapper.selectDdayAlerts");
    }

    @Override
    public void insert(CalibThermocouple c) {
        sqlSession.insert("CalibMapper.insert", c);
    }

    @Override
    public void update(CalibThermocouple c) {
        sqlSession.update("CalibMapper.update", c);
    }

    @Override
    public void updateAttach(Map<String, Object> params) {
        sqlSession.update("CalibMapper.updateAttach", params);
    }

    @Override
    public void softDelete(int calibId) {
        sqlSession.update("CalibMapper.softDelete", calibId);
    }
}
