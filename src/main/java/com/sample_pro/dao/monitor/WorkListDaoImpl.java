package com.sample_pro.dao.monitor;

import com.sample_pro.domain.WorkListItem;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class WorkListDaoImpl implements WorkListDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<WorkListItem> selectPendingWorkList(String equtCd) {
        return sqlSession.selectList("WorkListMapper.selectPendingWorkList", equtCd);
    }
}
