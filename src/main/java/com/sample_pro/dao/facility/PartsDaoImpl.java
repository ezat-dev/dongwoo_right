package com.sample_pro.dao.facility;

import com.sample_pro.domain.Parts;
import com.sample_pro.domain.StockHistory;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class PartsDaoImpl implements PartsDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override public List<Parts> selectPartsList(Map<String, Object> params) {
        return sqlSession.selectList("PartsMapper.selectPartsList", params);
    }
    @Override public Parts selectPartsByNo(String partNo) {
        return sqlSession.selectOne("PartsMapper.selectPartsByNo", partNo);
    }
    @Override public void insertParts(Parts p)   { sqlSession.insert("PartsMapper.insertParts", p); }
    @Override public void updateParts(Parts p)   { sqlSession.update("PartsMapper.updateParts", p); }
    @Override public void deleteParts(String partNo) { sqlSession.delete("PartsMapper.deleteParts", partNo); }

    @Override public List<StockHistory> selectHistoryList(Map<String, Object> params) {
        return sqlSession.selectList("PartsMapper.selectHistoryList", params);
    }
    @Override public void insertHistory(StockHistory h) { sqlSession.insert("PartsMapper.insertHistory", h); }
    @Override public void deleteHistory(int id)         { sqlSession.delete("PartsMapper.deleteHistory", id); }
}
