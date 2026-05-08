package com.sample_pro.dao.facility;

import com.sample_pro.domain.InspectHeader;
import com.sample_pro.domain.InspectItem;
import com.sample_pro.domain.InspectResult;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Repository
public class InspectDaoImpl implements InspectDao {

    @Resource(name = "session")
    private SqlSession sqlSession;

    @Override
    public List<InspectItem> selectItems(Map<String, Object> params) {
        return sqlSession.selectList("InspectMapper.selectItems", params);
    }

    @Override
    public InspectItem selectItemById(int itemId) {
        return sqlSession.selectOne("InspectMapper.selectItemById", itemId);
    }

    @Override
    public InspectHeader selectHeader(Map<String, Object> params) {
        return sqlSession.selectOne("InspectMapper.selectHeader", params);
    }

    @Override
    public List<InspectResult> selectResults(Map<String, Object> params) {
        return sqlSession.selectList("InspectMapper.selectResults", params);
    }

    @Override
    public void insertItem(InspectItem item) {
        sqlSession.insert("InspectMapper.insertItem", item);
    }

    @Override
    public void updateItem(InspectItem item) {
        sqlSession.update("InspectMapper.updateItem", item);
    }

    @Override
    public void updateItemDel(InspectItem item) {
        sqlSession.update("InspectMapper.updateItemDel", item);
    }

    @Override
    public void deleteItem(int itemId) {
        sqlSession.delete("InspectMapper.deleteItem", itemId);
    }

    @Override
    public void upsertHeader(InspectHeader header) {
        sqlSession.insert("InspectMapper.upsertHeader", header);
    }

    @Override
    public void upsertCell(InspectResult result) {
        sqlSession.insert("InspectMapper.upsertCell", result);
    }

    @Override
    public void updateItemImg(int itemId, String imgFile) {
        Map<String, Object> p = new java.util.HashMap<>();
        p.put("itemId", itemId);
        p.put("imgFile", imgFile);
        sqlSession.update("InspectMapper.updateItemImg", p);
    }
}
