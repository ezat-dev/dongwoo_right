package com.sample_pro.dao.monitor;

import com.sample_pro.domain.NowWorkItem;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;

@Repository
public class NowWorkDaoImpl implements NowWorkDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<NowWorkItem> selectByPageNo(int pageNo) {
        return sqlSession.selectList("NowWorkMapper.selectByPageNo", pageNo);
    }
}
