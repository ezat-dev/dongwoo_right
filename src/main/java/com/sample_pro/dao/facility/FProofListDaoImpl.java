package com.sample_pro.dao.facility;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class FProofListDaoImpl implements FProofListDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<Map<String, Object>> selectSessions(Map<String, Object> params) {
        return sqlSession.selectList("FProofListMapper.selectSessions", params);
    }

    @Override
    public List<Map<String, Object>> selectDetail(Map<String, Object> params) {
        return sqlSession.selectList("FProofListMapper.selectDetail", params);
    }
}
