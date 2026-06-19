package com.sample_pro.service.facility;

import com.sample_pro.dao.facility.FProofDao;
import com.sample_pro.domain.AlarmTag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("fProofService")
public class FProofServiceImpl implements FProofService {

    @Autowired
    private FProofDao fProofDao;

    @Override
    public List<AlarmTag> getAllTags(String plcId) {
        return fProofDao.selectAllTags(plcId);
    }

    @Override
    public List<Integer> getSelectedTagIds(String plcId) {
        return fProofDao.selectSelectedTagIds(plcId);
    }

    @Override
    @Transactional
    public void select(int tagId, String plcId) {
        Map<String, Object> p = new HashMap<>();
        p.put("tagId", tagId);
        p.put("plcId", plcId);
        fProofDao.insertSelected(p);
    }

    @Override
    @Transactional
    public void deselect(int tagId, String plcId) {
        Map<String, Object> p = new HashMap<>();
        p.put("tagId", tagId);
        p.put("plcId", plcId);
        fProofDao.deleteSelected(p);
    }
}
