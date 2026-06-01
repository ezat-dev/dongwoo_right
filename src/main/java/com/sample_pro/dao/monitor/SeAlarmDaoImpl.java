package com.sample_pro.dao.monitor;

import com.sample_pro.domain.SeAlarm;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class SeAlarmDaoImpl implements SeAlarmDao {

    @Resource(name = "htmsSession")
    private SqlSession sqlSession;

    @Override
    public List<SeAlarm> selectSeAlarmList(Map<String, Object> params) {
        return sqlSession.selectList("SeAlarmMapper.selectSeAlarmList", params);
    }

    @Override
    public List<Map<String, Object>> selectBcfTrendData(Map<String, Object> params) {
        return sqlSession.selectList("SeAlarmMapper.selectBcfTrendData", params);
    }
}
