package com.sample_pro.dao.facility;

import com.sample_pro.domain.ConsumableLedger;
import com.sample_pro.domain.ConsumableLedgerHistory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class ConsumableLedgerDaoImpl implements ConsumableLedgerDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override public List<ConsumableLedger> selectList() {
        return sqlSession.selectList("ConsumableLedgerMapper.selectList");
    }
    @Override public ConsumableLedger selectById(Long id) {
        return sqlSession.selectOne("ConsumableLedgerMapper.selectById", id);
    }
    @Override public void insert(ConsumableLedger item)  { sqlSession.insert("ConsumableLedgerMapper.insert", item); }
    @Override public void update(ConsumableLedger item)  { sqlSession.update("ConsumableLedgerMapper.update", item); }
    @Override public void updateStock(Map<String, Object> params) { sqlSession.update("ConsumableLedgerMapper.updateStock", params); }
    @Override public void delete(Long id) { sqlSession.update("ConsumableLedgerMapper.delete", id); }

    @Override public List<ConsumableLedgerHistory> selectHistoryList(Map<String, Object> params) {
        return sqlSession.selectList("ConsumableLedgerMapper.selectHistoryList", params);
    }
    @Override public void insertHistory(ConsumableLedgerHistory h) { sqlSession.insert("ConsumableLedgerMapper.insertHistory", h); }
    @Override public void deleteHistory(Long id) { sqlSession.delete("ConsumableLedgerMapper.deleteHistory", id); }
}
