package com.sample_pro.dao.facility;

import com.sample_pro.domain.AlarmTag;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class FProofDaoImpl implements FProofDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<AlarmTag> selectAllTags(String plcId) {
        return sqlSession.selectList("FProofMapper.selectAllTags", plcId);
    }

    @Override
    public List<Integer> selectSelectedTagIds(String plcId) {
        return sqlSession.selectList("FProofMapper.selectSelectedTagIds", plcId);
    }

    @Override
    public void insertSelected(Map<String, Object> params) {
        sqlSession.insert("FProofMapper.insertSelected", params);
    }

    @Override
    public void deleteSelected(Map<String, Object> params) {
        sqlSession.delete("FProofMapper.deleteSelected", params);
    }
}
