package com.sample_pro.dao.monitor;

import com.sample_pro.domain.WorkListItem;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class WorkListDaoImpl implements WorkListDao {

    @Resource(name = "htmsSession")
    private SqlSession sqlSession;

    @Override
    public List<WorkListItem> selectPendingWorkList(String equtCd) {
        return sqlSession.selectList("WorkListMapper.selectPendingWorkList", equtCd);
    }

    @Override
    public List<Map<String, Object>> selectJacupByRange(Map<String, Object> params) {
        return sqlSession.selectList("WorkListMapper.selectJacupByRange", params);
    }
}
